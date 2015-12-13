require 'test_helper'

class API::V1::OrdersControllerTest < ActionController::TestCase
  include APITestHelpers

  def setup
    set_request_headers
    @table = tables(:table1)
    @order = { name: "New Order",
               price: "123.45",
               quantity: 2,
               served: false,
               table_id: @table.id }
  end

  test "should create an order and return it as json" do
    assert_difference 'Order.count', 1 do
      post :create, order: @order
    end

    assert_response 201
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 5, json.keys.count
    assert_equal @order[:name],     json[:name]
    assert_equal @order[:price],    json[:price]
    assert_equal @order[:quantity], json[:quantity]
    assert_equal @order[:served],   json[:served]
    assert_equal @table.id,         json[:table_id]
  end

  test "should not create an order without a table and return error" do
    assert_no_difference 'Order.count' do
      @order[:table_id] = "0"
      post :create, order: @order
    end

    assert_response 422
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 1, json.keys.count
    assert json.key?(:errors)
    assert has_error_message(json[:errors], "table is invalid")
  end

  test "should not create an order with invalid fields and return error" do
    assert_no_difference 'Order.count' do
      @order[:name] = ""
      @order[:quantity] = "1.5"
      post :create, order: @order
    end

    assert_response 422
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 1, json.keys.count
    assert json.key?(:errors)
    assert has_error_message(json[:errors], "name can't be blank")
    assert has_error_message(json[:errors], "quantity must be an integer")
  end

end
