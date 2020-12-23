class Api::StocksController < ActionController::API
  before_action :set_supplier, only: [:index]

  def index
    @stocks = @supplier.all_stocks

    render json: @stocks
  end

  private

  def set_supplier
    @supplier = Supplier.find(params[:id])
  end
end
