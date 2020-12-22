class ParcelType < ApplicationRecord
  # others: 10 THB/ day/ 1 m^3 (1,000,000 cm^3)
  # supplementary_food: 1 THB/ day/ 1 cm^3
  # clothes: 20 THB/ day/ 1 kg (10,000 cm^3)

  validates :name,
    :fee_rate,
    :weight_conversion,
    :dimension_conversion,
  presence: true

  validates :calculate_by_weight,
    :calculate_by_dimension,
    :double_rate_each_day,
  inclusion: { in: [ true, false ] }

  def calculate_total_fee(weight, dimension, days)
    total_fee_per_day = calculate_total_fee_per_day(weight, dimension)

    return total_fee_per_day * days unless double_rate_each_day

    calculate_double_rate_each_day(fee_per_day, days)
  end

  def calculate_by_weight?
    calculate_by_weight
  end

  def calculate_by_dimension?
    calculate_by_dimension || true
  end

  def volume_in_m(volume_in_cm)
    volume_in_cm * 0.000001
  end

  def volume_to_weight_in_kg(volume_in_cm)
    volume_in_cm * 0.0001 # 10000 cm^3 = 1 kg
  end

  def weight_in_kg(weight_in_g)
    weight_in_g.to_f * 0.001
  end

  private

  def calculate_total_fee_per_day(weight, dimension)
    # if not calculate by weight, it will always calculate by dimension
    if weight.present? && calculate_by_weight
      weight * fee_rate * weight_conversion
    else
      dimension * fee_rate * dimension_conversion
    end
  end

  def calculate_double_rate_each_day(fee_per_day, days)
    total_fee = fee_per_day
    (1..days-1).each do |i| # second till last
      total_fee += (fee_per_day * i * 2)
    end

    total_fee
  end
end
