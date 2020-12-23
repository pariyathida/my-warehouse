class Api::ReportsController < ActionController::API
  def summary
    summary = {
      total_number_of_products: Summary.total_number_of_products,
      total_number_of_products_by_type: Summary.total_number_of_products_by_type,
      total_number_of_parcels: Summary.total_number_of_parcels,
      total_number_of_parcels_by_suppliers: Summary.total_number_of_parcels_by_suppliers,
      # add more ....
    }

    render json: summary
  end
end