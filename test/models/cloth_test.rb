require 'test_helper'

class ClothTest < ActiveSupport::TestCase
  def setup
    @fee = 20 # 20 THB/ day/ 1 kg (10,000 cm^3)
    @product  = products(:product_clothes)
    @import_date = @product.update(import_date: "09 Dec 2020 22:08:00 UTC +00:00")
    @export_date = @product.update(export_date: "10 Dec 2020 22:08:00 UTC +00:00")
  end

  #
  # 1 day range with 20 THB fees
  #

  # (use weight for calculation)
  test "that it returns a correct result when weight changed" do
    weight_in_g = [
      100,
      500,
      1000,
      3333,
      5000,
      10000,
      54321,
      100000,
      999999,
    ]

    weight_in_g.each do |w|
      @product.update(weight: w)
      expected_fee = @fee * 1 * (w.to_f / 1000) # 20 THB/ 1 day/ xx g.

      assert_equal expected_fee, @product.calculate_fee
    end
  end

  # (use dimension for calculation)
  test "that it returns a correct result when dimension changed" do
    @product.update(weight: 0) # to not be use in the calculation

    dimension_in_cm = [
      [1, 1, 1],
      [10, 10, 10],
      [200, 20, 50],
    ]

    dimension_in_cm.each do |w, l, h|
      @product.update(width: w, length: l, height: h)
      expected_fee = @fee * 1 * (w * l * h / 10000) # 20 THB/ 1 day/ xx g.

      assert_equal expected_fee, @product.calculate_fee
    end
  end

  #
  # 20 THB fees (use 1kg weight for calculation)
  #
  test "that it returns a correct result when number of days changed" do
    @product.update(weight: 1000) # 1kg

    dates = [
      [2, "08 Dec 2020 22:08:00 UTC +00:00"],
      [5, "05 Dec 2020 22:08:00 UTC +00:00"],
      [30, "10 Nov 2020 22:08:00 UTC +00:00"],
      [365, "11 Dec 2019 22:08:00 UTC +00:00"],
    ]

    dates.each do |days, date|
      @import_date = @product.update(import_date: date)
      expected_fee = @fee * days * 1 # 20 THB/ xx day/ 1 kg.
      assert_equal expected_fee, @product.calculate_fee
    end
  end
end
