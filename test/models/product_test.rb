require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  def setup
    @product  = products(:product_supplementary_food)
  end

  #
  # Validation
  #
  test "that it raises errors when fields are blank" do
    
  end

  #
  # Calculation
  #
  test "that it returns the correct day range calculation" do
  
    # different date, same time
    @product.update(import_date: "09 Dec 2020 22:08:00 UTC +00:00")
    @product.update(export_date: "10 Dec 2020 22:08:00 UTC +00:00")

    assert_equal 1, @product.day_range

    # different date, less than 24 hours fraction of the day
    @product.update(import_date: "09 Dec 2020 22:08:00 UTC +00:00")
    @product.update(export_date: "10 Dec 2020 20:09:00 UTC +00:00")

    assert_equal 1, @product.day_range

    # different date, more than 24 hours fraction of the day
    @product.update(import_date: "09 Dec 2020 18:08:00 UTC +00:00")
    @product.update(export_date: "10 Dec 2020 20:08:00 UTC +00:00")

    assert_equal 2, @product.day_range
  end

  test "that it returns error if export date is not after the import date" do
    @product.update(import_date: "11 Dec 2020 20:08:00 UTC +00:00")
    @product.update(export_date: "10 Dec 2020 20:08:00 UTC +00:00")

    assert_equal ["Export date must be after the import_date"], @product.errors.full_messages
  end
end
