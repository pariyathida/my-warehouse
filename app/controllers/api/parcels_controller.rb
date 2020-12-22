class Api::ParcelsController < ActionController::API
  def index
    @parcels = Parcels.all

    render json: @parcels
  end
end
