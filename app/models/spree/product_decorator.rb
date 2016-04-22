Spree::Product.class_eval do

  def option_values
    @option_values ||= Spree::OptionValue.for_product(self).order(:position).sort_by {|ov| ov.option_type.position }
  end

  def grouped_option_values
    @grouped_option_values ||= option_values.group_by(&:option_type)
  end

  def variants_for_option_value(value)
    @variant_option_values ||= variants_including_master.includes(:option_values).to_a
    @variant_option_values.select { |i| i.option_value_ids.include?(value.id) } # TODO ugly?
  end

  # stock items for any variant that has an option value that is passed in
  def stock_items_for_option_value(value)
    Spree::StockItem.includes(variant: :option_values).where(spree_option_values: {id: value.id}, spree_variants: {product_id: self.id})
  end

  def option_value_backorderable?(value)
    stock_items_for_option_value(value).where(:backorderable => true).any?
  end

  def option_value_in_stock?(value)
    self.option_value_backorderable?(value) || self.stock_items_for_option_value(value).to_a.sum(&:count_on_hand) > 0
  end

  def variant_options_hash
    return @variant_options_hash if @variant_options_hash
    hash = {}
    self.variants_including_master.includes(:option_values).each do |variant|
      variant.option_values.each do |value|
        type_id = value.option_type_id.to_s
        value_id = value.id.to_s
        hash[type_id] ||= {}
        hash[type_id][value_id] ||= {}
        hash[type_id][value_id][variant.id.to_s] = variant.to_hash
      end
    end
    @variant_options_hash = hash
  end

end
