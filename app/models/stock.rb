class Stock < ApplicationRecord
  has_one :parcel
  has_one :product
  has_one :location
  belongs_to :supplier

  def add_stock()
    # TODO: includes parcel_id
    # TODO: includes product_id and product_amount 
    # TODO: includes location that store this parcel or product
    # TODO: check location available

    # stock = Stock.new(parcel_id, product_id, product_amount, location_id)
    # stock.save

    # TODO: need to think about how to include details such as 'expired date', 'chemical concern', 
  end

  def update_stock()
    # used for updating the stock when some products are taken out
  end

  def remove_stock()
    # TODO: update product_amount to 0
    # TODO: update parcel.in_stock to false
  end

  def available_product
    # TODO: list all available products in stock
  end

  def is_empty?
    product_amount == 0
  end
end
