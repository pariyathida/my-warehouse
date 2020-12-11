class SupplementaryFood < Product
  FEE = 1 # 1 THB/ day/ 1 cm^3

  def calculate_fee
    total_fee = FEE * volume_in_cm

    (1..day_range-1).each do |i|
      total_fee += (FEE * volume_in_cm)*(i*2)
    end

    total_fee.to_f
  end
end
