class Parcel < ApplicationRecord

  validates :weight,
    :width,
    :length,
    :height,
    :import_date,
    :export_date,
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

  def calculate_date_range
    calculate_number_of_days(import_date, export_date)
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
