require 'spec_helper'

module Spree
  class WishedProduct
    include ActiveModel::Conversion
    extend ActiveModel::Naming

    attr_accessor :variant_id

    def persisted?
      false
    end
  end
end

describe 'variant options', type: :feature do
  let!(:product) { create(:product) }
  let!(:color) { create(:option_type, :name => "Color") }
  let!(:size) { create(:option_type, name: 'Size') }
  let!(:small) { create(:option_value, :presentation => "S", :name => "S", :option_type => size) }
  let!(:medium) { create(:option_value, :presentation => "M", :name => "M", :option_type => size) }
  let!(:red) { create(:option_value, :name => "Red", :presentation => "Red", :option_type => color) }
  let!(:green) { create(:option_value, :name => "Green", :presentation => "Green", :option_type => color) }
  let!(:variant1) { create(:variant, :product => product, :option_values => [small, red]) }
  let!(:variant2) { create(:variant, :product => product, :option_values => [small, green]) }
  let!(:variant3) { create(:variant, :product => product, :option_values => [medium, red]) }
  let!(:variant4) { create(:variant, :product => product, :option_values => [medium, green]) }

  before do
    visit spree.product_path(product)
  end

  context 'with inventory tracking', :js => true do

    before(:each) do

      # implicitly creates stock items for each variant
      location = Spree::StockLocation.first_or_create! name: 'default'
      location.active = true
      location.country =  Spree::Country.where(iso: 'US').first
      location.save!

      # default is true, rather than overriding factory
      Spree::StockItem.update_all :backorderable => false

      # adjust stock items count on hand
      [variant1, variant2, variant3].each do |variant|
        variant.stock_items.each { |stock_item| Spree::StockMovement.create(:quantity => 0, :stock_item => stock_item) }
      end
      variant4.stock_items.each { |stock_item| Spree::StockMovement.create(:quantity => 1, :stock_item => stock_item) }

    end

    it 'should disallow choose out of stock variants' do

      # variant options are not selectable
      within("#product-variants") do
        size = find_link('S')
        size.click
        expect(size["class"].include?("selected")).to be_truthy
        color = find_link('Green')
        color.click
        expect(color["class"].include?("selected")).to be_truthy
      end

    end

    it 'should allow choose out of stock variants' do
      # variant options are selectable
      within("#product-variants") do
        size = find_link('S')
        size.click
        expect(size["class"].include?("selected")).to be_truthy
        color = find_link('Green')
        color.click
        expect(color["class"].include?("selected")).to be_truthy
      end

    end

    it "should choose in stock variant" do

      within("#product-variants") do
        size = find_link('M')
        size.click
        expect(size["class"].include?("selected")).to be_truthy
        color = find_link('Green')
        color.click
        expect(color["class"].include?("selected")).to be_truthy
      end

    end
  end

  context 'without inventory tracking', :js => true do
    it "should choose variant with track_inventory_levels to false" do

      within("#product-variants") do
        size = find_link('S')
        expect(size["class"].include?("selected")).to be_truthy
        color = find_link('Red')
        expect(color["class"].include?("selected")).to be_truthy
      end
    end
  end
end
