class Api::ParcelTypesController < ActionController::API
  before_action :set_parcel_type, only: [:update]

  def index
    @parcel_type = ParcelType.all

    render json: @parcel_type
  end

  def create
    @parcel_type = ParcelType.new(permitted_params)

    if @parcel_type.valid?
      @parcel_type.save

      render json: @parcel_type
    else
      render_failed_validation
      render status: :bad_request, json: {
        status: "error",
        message: @parcel_type.errors.full_messages.to_sentence.downcase,
      }
    end
  end

  def update
    unless @parcel_type.present?
      render_not_found
    else
      @parcel_type.update(permitted_params)

      if @parcel_type.valid?
        @parcel_type.save

        render json: @parcel_type
      else
        render_failed_validation
      end
    end
  end

  private

  def set_parcel_type
    @parcel_type = ParcelType.find_by(name: params[:name])
  end

  def permitted_params
    params.required(:parcel_type).permit(
      :name,
      :calculate_by_weight,
      :double_rate_each_day,
      :fee_rate,
      :currency,
      :weight_conversion,
      :dimension_conversion,
    ).merge(
      calculate_by_dimension: true,
    )
  end

  def render_not_found
    render status: :not_found, json: {
      status: "error",
      message: "parcel type #{params[:name]} was not found",
    }
  end

  def render_failed_validation
    render status: :bad_request, json: {
      status: "error",
      message: @parcel_type.errors.full_messages.to_sentence.downcase,
    }
  end
end