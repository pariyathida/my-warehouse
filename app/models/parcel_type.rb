class ParcelType < ApplicationRecord
  # others: 10 THB/ day/ 1 m^3 (1,000,000 cm^3)
  # supplementary_food: 1 THB/ day/ 1 cm^3
  # clothes: 20 THB/ day/ 1 kg (10,000 cm^3)

  validates :type_name,
    :calculate_by_weight,
    :calculate_by_dimension,
    :double_rate_each_day,
    :fee_rate,
    :conversion_rate,
  presence: true

  def find_type
    ParcelType.find_by(type_name: type_name)
  end

  def calculate_total_fee(weight, dimension, days)
    if weight.present? && calculate_by_weight
      total_fee_per_day = weight * fee_rate * weight_conversion
    else
      total_fee_per_day = dimension * fee_rate * dimension_conversion
    end

    return total_fee_per_day * days unless double_rate_each_day

    # calculate double rate each day
    total_fee = total_fee_per_day
    (1..days-1).each do |i| # second till last
      total_fee += (total_fee_per_day * i * 2)
    end

    total_fee
  end

  def calculate_by_weight?
    calculate_by_weight
  end

  def calculate_by_dimension?
    calculate_by_dimension
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
end
