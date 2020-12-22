require 'test_helper'

class ParcelTypeTest < ActiveSupport::TestCase
  test "it can calculate the total fees for cloth" do
    parcel_type = parcel_types(:cloth)

    weight = 1000 # g
    assert_equal 20, parcel_type.calculate_total_fee(weight, nil, 1)
    assert_equal 100, parcel_type.calculate_total_fee(weight, nil, 5)

    dimension = 100000
    assert_equal 200, parcel_type.calculate_total_fee(nil, dimension, 1)
    assert_equal 1000, parcel_type.calculate_total_fee(nil, dimension, 5)
  end

  test "it can calculate the total fees for supplementary food" do
    parcel_type = parcel_types(:supplementary_food)

    dimension = 100 # cm^3
    assert_equal 2000, parcel_type.calculate_total_fee(nil, dimension, 1)
    assert_equal 6000, parcel_type.calculate_total_fee(nil, dimension, 2)
  end

  test "it can calculate the total fees for other" do
    parcel_type = parcel_types(:other)

    dimension = 1000000 # cm^3
    assert_equal 10, parcel_type.calculate_total_fee(nil, dimension, 1)
    assert_equal 20, parcel_type.calculate_total_fee(nil, dimension, 2)
  end
end
