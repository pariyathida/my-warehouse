class Cloth < Product
  FEE = 20 # 20 THB/ day/ 1 kg (10,000 cm^3)

  ##### validate either weight or dimension must be provided

  def calculate_fee
    if weight > 0
      (FEE * day_range * weight_in_kg).to_f
    else
      (FEE * day_range * volume_to_weight_in_kg).to_f
    end
  end
end
