require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  def setup
    @product  = products(:product_supplementary_food)
  end

  #
  # Validation
  #
  test "that it raises errors when fields are blank" do
    product = Product.new(id: 1)

    assert_equal false, product.valid?
    assert_equal "can't be blank", product.errors[:type].first
    assert_equal "can't be blank", product.errors[:name].first
    assert_equal "can't be blank", product.errors[:import_date].first
    assert_equal "can't be blank", product.errors[:export_date].first
    assert_equal "can't be blank", product.errors[:weight].first
    assert_equal "can't be blank", product.errors[:width].first
    assert_equal "can't be blank", product.errors[:length].first
    assert_equal "can't be blank", product.errors[:height].first
  end

  test "that it raises errors if weight, width, length, height is not an integer or isn't greater than or equal to 0" do
    @product.update(weight: "a", width: -1, length: 5.5, height: ".")

    assert_equal false, @product.valid?
    assert_equal "is not a number", @product.errors[:weight].first
    assert_equal "must be greater than or equal to 0", @product.errors[:width].first
    assert_equal "must be an integer", @product.errors[:length].first
    assert_equal "is not a number", @product.errors[:height].first
  end

  # for types that require weight, either weight or dimension should be provided
  test "that it raises errors if weight or dimension is required but not provided" do
    product = products(:product_clothes) # type: Cloth
    product.update(weight: 0, width: 0, length: 0, height: 0)

    assert_equal false, product.valid?
    assert_equal "or dimension must be provided", product.errors[:weight].first
  end

  # for types that not required weight, dimension should be provided
  test "that it raises errors if weight is not required but dimension is not provided" do
    product = products(:product_others) # type: Other
    product.update(weight: 0, width: 0, length: 0, height: 0)

    assert_equal false, product.valid?
    assert_equal "must be provided", product.errors[:width].first
    assert_equal "must be provided", product.errors[:length].first
    assert_equal "must be provided", product.errors[:height].first
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
