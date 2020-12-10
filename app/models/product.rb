class Product < ApplicationRecord
  FEE = 1
  TYPE_MAPPING = {
    supplementary_food: "SupplementaryFood",
    cloth: "Cloth",
  }.freeze

  #
  # Validations
  #

  validates :type,
    :name,
    :import_date,
    :export_date,
    :weight,
    :width,
    :length,
    :height,
  presence: true

  validate :available_date_range?

  def available_date_range?
    return false if import_date.nil? || export_date.nil?

    unless day_range > 0
      errors.add(:export_date, "must be after the import_date")
    end
  end

  #
  # Summary
  #

  def self.all_products_in_warehouse
    where(exported: false)
  end

  def self.find_by_type(type)
    where(type: type)
  end

  def self.total_profit
    sum_profit(all_products_in_warehouse)
  end

  def self.profit_by_type(type)
    products = find_by_type(type)
    
    sum_profit(products)
  end

  def self.sum_profit(products)
    profit = 0

    products.each do |product|
      profit += product.calculate_fee
    end

    profit
  end

  #
  # Calculation
  #

  def calculate_fee
    (FEE * day_range * volume_in_m).to_f
  end

  def day_range
    calculate_number_of_days(import_date, export_date)
  end

  def volume_in_cm
    calculate_volume(width, length, height)
  end

  def volume_in_m
    calculate_volume(width, length, height) * 0.000001
  end

  def volume_to_weight_in_kg
    volume_in_cm / 10000 # 10000 cm^3 = 1 kg
  end

  def weight_in_kg
    weight.to_f / 1000
  end

  private

  def calculate_number_of_days(start_date, end_date)
    d1 = DateTime.parse(start_date.to_s)
    d2 = DateTime.parse(end_date.to_s)
    fraction_of_the_day = time_count(d1, d2)
    days_range = (d1.to_date .. d2.to_date).count - 1
    

    days_range + fraction_of_the_day
  end

  def time_count(start_time, end_time)
    h1 = get_hour(start_time)
    h2 = get_hour(end_time)
    m1 = get_minute(start_time)
    m2 = get_minute(end_time)

    return 0 if ( h1 > h2 ) || ( h1 == h2 && m1 >= m2 )
    
    1
  end

  def get_hour(time)
    time.strftime("%H").to_i
  end

  def get_minute(time)
    time.strftime("%M").to_i
  end

  def calculate_volume(width, length, height)
    width * length * height
  end
end
