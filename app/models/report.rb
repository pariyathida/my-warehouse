class Report < ApplicationRecord
  class << self
    # number of products in our warehouse

    def total_number_of_products
    end

    def total_number_of_products_by_type
      # ex. "type: {name}, {number}"
    end

    # number of parcels in our warehouse

    def total_number_of_parcels
    end

    def total_number_of_parcels_by_suppliers
    end

    # warehouse's incoming balance from goods storing

    def total_storing_balance # storing fee
    end

    def total_storing_balance_by_type # storing fee by type
    end

    def total_storing_balance_by_product # storing fee product
    end

    def total_storing_balance_by_supplier # storing fee by supplier
    end

    # warehouse's profit from picking

    def total_picking_balance
    end

    def total_picking_balance_by_type # storing fee by type
    end

    def total_picking_balance_by_product # storing fee product
    end

    def total_picking_balance_by_supplier # storing fee by supplier
    end

    # warehouse's profit from packing

    def total_packing_balance
    end

    def total_packing_balance_by_type # storing fee by type
    end

    def total_packing_balance_by_product # storing fee product
    end

    def total_packing_balance_by_supplier # storing fee by supplier
    end

    # cost from shipping

    def total_shipping_cost
    end

    def shipping_cost_from_each_shipping_company   
    end

    def shipping_cost_from_each_shipping_company(by_supplier)
    end

    # customer details

    # TODO: ex. age, gender, location ...

    # payments

    # TODO: ex. payment channels, ...
  end
end
