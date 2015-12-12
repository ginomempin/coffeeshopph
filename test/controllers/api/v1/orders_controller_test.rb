require 'test_helper'

class API::V1::OrdersControllerTest < ActionController::TestCase

  def setup
    @request.headers['Accept'] = 'application/vnd.coffeeshop.v1'
    @request.headers['Content-Type'] = 'application/json'
    @table = tables(:table1)
    @order = { name: "New Order",
               price: 123.45,
               quantity: 2,
               table_id: @table.id }
  end

  test "should create an order and return it as json" do
    assert_difference 'Order.count', 1 do
      post :create, { order: @order },
                    { format: :json }
    end

    assert_response 201
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal "New Order", json[:name]
    assert_equal "123.45",    json[:price]
    assert_equal 2,           json[:quantity]
    assert_equal @table.id,   json[:table_id]
  end

  test "should not create an order without a table and return error" do
    assert_no_difference 'Order.count' do
      @order[:table_id] = 0
      post :create, { order: @order },
                    { format: :json }
    end

    assert_response 422
    json = parse_json_from(@response)
    assert_not_nil json

    assert json.key?(:errors)
    assert_not json[:errors].empty?
    assert has_error_message(json[:errors], "table is invalid")
  end

  test "should not create an order with invalid fields and return error" do
    assert_no_difference 'Order.count' do
      @order[:name] = ""
      @order[:quantity] = 1.5
      post :create, { order: @order },
                    { format: :json }
    end

    assert_response 422
    json = parse_json_from(@response)
    assert_not_nil json

    assert json.key?(:errors)
    assert_not json[:errors].empty?
    assert has_error_message(json[:errors], "name can't be blank")
    assert has_error_message(json[:errors], "quantity must be an integer")
  end

end
