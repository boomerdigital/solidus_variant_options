Spree::Variant.class_eval do

  include ActionView::Helpers::NumberHelper

  def to_hash
    actual_price  = self.price
    {
      :id    => self.id,
      :count => self.stock_items.to_a.sum(&:count_on_hand),
      :price => number_to_currency(actual_price),
      :backorderable => self.stock_items.where(:backorderable => true).any?
    }
  end

end
