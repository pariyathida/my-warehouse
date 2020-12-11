class ProductsController < ApplicationController
# this class is for http://localhost:3000/

  def index
    @product = Product.all
  end

  def show
    @product = Product.find_by(id: params[:id])

    @product
  end

  def create
    @product = Product.new(permitted_params)

    if @product.save
      redirect_to products_path
    else
      redirect_to products_path
    end
  end

  private

  def permitted_params
    params.required(:product).permit(
      :type,
      :import_date,
      :export_date,
      :name,
      :weight,
      :width,
      :length,
      :height,
    ).merge(exported: false)
  end
end
