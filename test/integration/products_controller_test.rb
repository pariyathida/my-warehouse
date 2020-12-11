require 'test_helper'

class Api::ProductsTest < ActionDispatch::IntegrationTest
  def app
    Rails.application
  end

  #
  # index
  #
  test "that it can get all products information" do
    get api_products_path

    assert_response 200
    assert_equal 3, JSON.parse(response.body).count
  end

  #
  # show
  #
  test "that it can return a product details" do
    get api_products_path + "/1"

    expected_response = {
      "id"=>1,
      "name"=>"product_supplementary_food",
      "description"=>"null,",
      "import_date"=>"2020-12-08T22:08:00.000Z",
      "export_date"=>"2020-12-10T22:08:00.000Z",
      "weight"=>0,
      "width"=>10,
      "length"=>10,
      "height"=>10,
      "total_fee"=>nil,
      "created_at"=>"2020-12-11T05:29:37.041Z",
      "updated_at"=>"2020-12-11T05:29:37.041Z",
      "warehouse_id"=>nil,
      "exported"=>false
    }
    
      assert_response 200
      assert_equal expected_response, JSON.parse(response.body)
  end

  #
  # create
  #
  test "that it can create a product" do
    assert_difference "Product.count", 1 do
      post api_products_path, params: {
        product: {
          name: "Tshirt",
          type: "Cloth",
          import_date: "2020-12-09T22:08:00.000Z",
          export_date: "2020-12-10T22:08:00.000Z",
          weight: 0,
          width: 100,
          length: 20,
          height: 20
        }
      }
    end

    assert_response 200
    assert_equal "Tshirt", JSON.parse(response.body)["name"]
  end

  ##### test wrong type

  #
  # export
  #
  test "that the product can be exported" do
    product = products(:product_supplementary_food)
    assert_equal false, product.exported

    post api_products_path + "/1/export"

    assert_response 200
    assert product.reload.exported
  end

  #
  # summary assert not blank
  #
  test "that it shows the summary" do
    get api_summary_path

    assert_response 200
    res = JSON.parse(response.body)
    
    assert_not_nil res["total_number_of_products"]
    assert_not_nil res["number_of_products_in_warehouse"]
    assert_not_nil res["number_of_clothes"]
    assert_not_nil res["number_of_supplementary_food"]
    assert_not_nil res["number_of_others"]
    assert_not_nil res["total_profit"]
    assert_not_nil res["profit_from_clothes"]
    assert_not_nil res["profit_from_supplementary_food"]
    assert_not_nil res["profit_from_others"]
  end
end
