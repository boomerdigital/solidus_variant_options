require 'spec_helper'

describe Spree::OptionValue do

  before(:each) do
    @images = Dir[File.expand_path("../../../support/images/*", __FILE__)]
  end

  context "a new option value" do
    before(:each) do
      @option_value = Spree::OptionValue.new
    end

    it "should not have an image" do
      assert !@option_value.has_image?
    end
  end

  context "an existing option value" do
    before(:each) do
      @option_value = create(:option_value)
    end

    it "should not have an image" do
      assert !@option_value.has_image?
    end

    context "with an image" do
      before(:each) do
        @path = @images.shuffle.first
        file = File.open(@path)
        @option_value.update_attributes(:image => file)
        file.close
      end

      it "should have an image" do
        assert @option_value.has_image?
      end

      it "should have small large and original images" do
        dir = File.expand_path("../../../dummy/public/spree/option_values/#{@option_value.id}", __FILE__)
        %w(small large original).each do |size|
          assert File.exists?(File.join(dir, size, File.basename(@path)))
        end
      end
    end
  end

  context "#for_product" do
    before(:each) do
      @product = create(:product_with_variants)
    end

    it "should return uniq option_values" do
      unused = create(:option_value, :option_type => @product.option_types.first, :presentation => "Unused")
      assert !Spree::OptionValue.for_product(@product).include?(unused)
    end

    it "should retain option values sort order" do
      @unordered, @prev_position = false, 0
      Spree::OptionValue.for_product(@product).load.each do |ov|
        @unordered = true if @prev_position > ov.position
        @prev_position = ov.position
      end

      assert !@unordered
    end

    it "should return empty array when no variants" do
      product = create(:product)
      assert_equal [], Spree::OptionValue.for_product(product)
    end
  end

end
