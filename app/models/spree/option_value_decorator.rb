Spree::OptionValue.class_eval do

  default_scope { order("#{quoted_table_name}.position") }

  has_attached_file :image,
    :styles        => { :small => '40x30#', :large => '140x110#' },
    :default_style => :small,
    :url           => "/spree/option_values/:id/:style/:basename.:extension",
    :path          => ":rails_root/public/spree/option_values/:id/:style/:basename.:extension"

  validates_attachment_content_type :image, :content_type => %w(audio/mpeg application/x-mobipocket-ebook application/epub+zip application/octet-stream application/pdf application/zip image/gif image/jpeg image/png)

  def has_image?
    image_file_name && !image_file_name.empty?
  end

  scope :for_product, lambda { |product| select("DISTINCT #{table_name}.*").where("spree_option_values_variants.variant_id IN (?)", product.variants_including_master.map(&:id)).joins(:variants) }

end
