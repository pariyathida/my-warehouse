class Api::ProductsController < ActionController::API
  def index
    @products = Product.all

    render json: @products
  end

  def show
    @product = Product.find_by(id: params[:id])

    render json: @product
  end

  def create
    @product = Product.new(permitted_params)

    if @product.valid?
      @product.update(total_fee: @product.calculate_fee) # calculate fee and save to database
      @product.save

      render json: @product
    else
      render status: :bad_request, json: {
        status: "error",
        message: @product.errors.full_messages.to_sentence.downcase,
      }
    end
  end

  def export
    @product = Product.find_by(id: params[:id])

    @product.update(exported: true)
    @product.save
    
    render json: @product
  end

  def summary
    summary = {
      total_number_of_products: Product.all.count,
      number_of_products_in_warehouse: Product.all_products_in_warehouse.count,
      number_of_clothes: Product.find_by_type("Cloth").count,
      number_of_supplementary_food: Product.find_by_type("SupplementaryFood").count,
      number_of_others: Product.find_by_type("Others").count,
      total_profit: Product.total_profit,
      profit_from_clothes: Product.profit_by_type("Cloth"),
      profit_from_supplementary_food: Product.profit_by_type("SupplementaryFood"),
      profit_from_others: Product.profit_by_type("Others"),
    }

    render json: summary
  end

  private

  def permitted_params
    params.required(:product).permit(
      :import_date,
      :export_date,
      :name,
      :description,
      :weight,
      :width,
      :length,
      :height,
      :type,
    ).merge(
      exported: false, # false by default, it means "imported"
      type: type_mapping,
    )
  end

  def type_mapping
    # If type isn't available (not in the list) then it will just go for "Others"
    # This helps protect the system not to be crashed when someone send a wrong type.
    if Product::TYPE_MAPPING.value?(params[:product][:type])
      params[:product][:type]
    else
      "Other"
    end
  end
end
