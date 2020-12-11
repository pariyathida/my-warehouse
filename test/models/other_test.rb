require 'test_helper'

class OtherTest < ActiveSupport::TestCase
  def setup
    @fee = 10 # 10 THB/ day/ 1 m^3 (1,000,000 cm^3)
    @product  = products(:product_others)
    @import_date = @product.update(import_date: "09 Dec 2020 22:08:00 UTC +00:00")
    @export_date = @product.update(export_date: "10 Dec 2020 22:08:00 UTC +00:00")
  end

  #
  # validation test
  #
  test "that it is valid if dimension provided" do
    @product.update(weight: 0, width: 20, length: 20, height: 20)

    assert @product.valid?
  end

  test "that it is not valid if dimension is not provided" do
    test_value = [
      [ 0, 0, 0, 0 ],
      [ 10, 0, 0, 0],
      [ 0, "a", 10, 10],
      [ 0, 5.5, 10, 10],
    ]

    test_value.each do |weight, w, l, h|
      @product.update(weight: weight, width: w, length: l, height: h)

      assert_equal false, @product.valid?
    end
  end

  #
  # 1 day range with 10 THB fees (use dimension for calculation)
  #
  test "that it returns a correct result when dimension changed" do
    @product.update(weight: 0) # to not be use in the calculation

    dimension_in_cm = [
      [1, 1, 1],
      [10, 10, 10],
      [200, 20, 50],
      [1000, 1000, 1000],
    ]

    dimension_in_cm.each do |w, l, h|
      @product.update(width: w, length: l, height: h)
      expected_fee = @fee * 1 * (w * l * h * 0.000001) # 10 THB/ 1 day/ xx m^3

      assert_equal expected_fee, @product.calculate_fee
    end
  end

  #
  # 10 THB fees (use 10*10*10 dimension for calculation)
  #
  test "that it returns a correct result when number of days changed" do
    @product.update(width: 100, length: 100, height: 100)

    dates = [
      [2, "08 Dec 2020 22:08:00 UTC +00:00"],
      [5, "05 Dec 2020 22:08:00 UTC +00:00"],
      [30, "10 Nov 2020 22:08:00 UTC +00:00"],
      [365, "11 Dec 2019 22:08:00 UTC +00:00"],
    ]

    dates.each do |days, date|
      @import_date = @product.update(import_date: date)
      expected_fee = @fee * days * (100 * 100 * 100 * 0.000001)
      # 10 THB/ xx day/ 100000 cm^3. (*0.000001 to convert to m^3)
      assert_equal expected_fee, @product.calculate_fee
    end
  end
end
