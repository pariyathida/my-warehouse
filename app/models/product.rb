class Product < ApplicationRecord
  FEE = 1 # default set but not used

  # manually add more type here when adding a new product type
  # ( plan to make the subclass list itself to the superclass,
  # so that this list will update itself automatically )
  TYPE_MAPPING = {
    supplementary_food: "SupplementaryFood",
    cloth: "Cloth",
    other: "Other",
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

  validates :weight,
    :width,
    :length,
    :height,
  numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validate :available_date_range? # check that the export date must be after the import date
  validate :weight_or_dimension_provided? # validate either weight or dimension must be provided

  def available_date_range?
    return false if import_date.nil? || export_date.nil?

    unless day_range > 0
      errors.add(:export_date, "must be after the import_date")
    end
  end

  def weight_or_dimension_provided?
    if weight_required?
      unless weight_provided? || dimension_provided?
        errors.add(:weight, "or dimension must be provided")
      end
    else
      unless dimension_provided?
        errors.add(:width, "must be provided")
        errors.add(:length, "must be provided")
        errors.add(:height, "must be provided")
      end
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
  # These are a main calculation method which can be called by each subclass
  #

  # this method will be overrided by each subclass
  def calculate_fee
    (FEE * day_range * volume_in_m).to_f
  end

  # คลังต้องการคิดค่าบริการลูกค้าตามจำนวนวันที่ลูกค้านำสินค้ามาเก็บไว้ จนถึงวันที่ลูกค้านำสินค้าออกจากคลัง
  # โดยไม่สนใจเศษของวัน แต่คิดค่าบริการขั้นต่ำ 1 วัน 
  # (ตัวอย่าง เก็บวันที่ 12/04/2019 เวลา 12.00 และ นำออกวันที่ 14/04/2019 เวลา 08.00 คิดค่าบริการ 2 วัน)
  def day_range
    calculate_number_of_days(import_date, export_date)
  end

  def volume_in_cm
    calculate_volume(width, length, height)
  end

  def volume_in_m
    volume_in_cm * 0.000001
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

    # ex. 19-10-2020..19-10-2020 = 1 day
    # ex. 19-10-2020..20-10-2020 = 2 day
    days_range = (d1.to_date .. d2.to_date).count - 1

    days_range + fraction_of_the_day
  end

  # calculate fraction of the day by using time in hour and min
  # if end_time is more than start_time, return 1 (day), otherwise return 0 (day)
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

  def weight_required?
    type == "Cloth"
  end

  def dimension_provided?
    width > 0 && height > 0 && length > 0
  rescue
    false
  end

  def weight_provided?
    weight > 0
  rescue
    false
  end
end
