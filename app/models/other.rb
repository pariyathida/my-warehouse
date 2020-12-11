class Other < Product
  FEE = 10 # 10 THB/ day/ 1 m^3 (1,000,000 cm^3)

  def calculate_fee
    (FEE * day_range * volume_in_m).to_f
  end
end
