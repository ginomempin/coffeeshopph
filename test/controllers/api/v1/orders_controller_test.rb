require 'test_helper'

class API::V1::OrdersControllerTest < ActionController::TestCase
  include APITestHelpers

  def setup
    @user = users(:user1)
    @table = tables(:table1)
    @pending_order = orders(:order3)
    @new_order = orders(:order11)
    @other_order = orders(:order4)
  end

  test "logged-out and create order" do
    set_request_headers # no authentication token
    assert_no_difference 'Order.count' do
      post :create, { table_id: @table.id,
                      order: {
                        name: @new_order.name,
                        price: @new_order.price,
                        quantity: @new_order.quantity
                      }
                    }
    end

    assert_response 401
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 1, json.keys.count
    assert json.key?(:errors)
    assert has_error_message(json[:errors], "user is unauthorized")
  end

  test "logged-in and create a valid order" do
    set_request_headers(@user)
    assert_difference 'Order.count', 1 do
      post :create, { table_id: @table.id,
                      order: {
                        name: @new_order.name,
                        price: @new_order.price,
                        quantity: @new_order.quantity
                      }
                    }
    end

    assert_response 201
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 5, json.keys.count
    assert_not_nil Order.find(json[:id])
    assert_equal @new_order.name,       json[:name]
    assert_equal @new_order.price.to_s, json[:price]
    assert_equal @new_order.quantity,   json[:quantity]
    assert_not                          json[:served]
  end

  test "logged-in and create an order with an invalid table" do
    set_request_headers(@user)
    assert_no_difference 'Order.count' do
      post :create, { table_id: 0,
                      order: {
                        name: @new_order.name,
                        price: @new_order.price,
                        quantity: @new_order.quantity
                      }
                    }
    end

    assert_response 422
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 1, json.keys.count
    assert json.key?(:errors)
    assert has_error_message(json[:errors], "table is invalid")
  end

  test "logged-in and create an order with invalid fields" do
    set_request_headers(@user)
    assert_no_difference 'Order.count' do
      @new_order.name = ""
      @new_order.quantity = 0
      post :create, { table_id: @table.id,
                      order: {
                        name: @new_order.name,
                        price: @new_order.price,
                        quantity: @new_order.quantity
                      }
                    }
    end

    assert_response 422
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 1, json.keys.count
    assert json.key?(:errors)
    assert has_error_message(json[:errors], "name can't be blank")
    assert has_error_message(json[:errors], "quantity must be greater than or equal to 1")
  end

  test "logged-out and list orders" do
    set_request_headers # no authentication token
    get :index, table_id: @table.id

    assert_response 401
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 1, json.keys.count
    assert json.key?(:errors)
    assert has_error_message(json[:errors], "user is unauthorized")
  end

  test "logged-in and list all orders for valid table" do
    set_request_headers(@user)
    get :index, table_id: @table.id

    assert_response 200
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 3, json.count
    assert_equal 5, json[0].keys.count
    expected_order = orders(:order1) # most recent first
    assert_equal expected_order.id,         json[0][:id]
    assert_equal expected_order.name,       json[0][:name]
    assert_equal expected_order.price.to_s, json[0][:price]
    assert_equal expected_order.quantity,   json[0][:quantity]
    assert_equal expected_order.served,     json[0][:served]
  end

  test "logged-in and list served orders for valid table" do
    set_request_headers(@user)
    get :index, { table_id: @table.id, served: true }

    assert_response 200
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 1, json.count
    assert_equal 5, json[0].keys.count
    expected_order = orders(:order2) # most recent first
    assert_equal expected_order.id,         json[0][:id]
    assert_equal expected_order.name,       json[0][:name]
    assert_equal expected_order.price.to_s, json[0][:price]
    assert_equal expected_order.quantity,   json[0][:quantity]
    assert_equal expected_order.served,     json[0][:served]
  end

  test "logged-in and list pending orders for valid table" do
    set_request_headers(@user)
    get :index, { table_id: @table.id, served: false }

    assert_response 200
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 2, json.count
    assert_equal 5, json[1].keys.count
    expected_order = orders(:order3) # most recent first
    assert_equal expected_order.id,         json[1][:id]
    assert_equal expected_order.name,       json[1][:name]
    assert_equal expected_order.price.to_s, json[1][:price]
    assert_equal expected_order.quantity,   json[1][:quantity]
    assert_equal expected_order.served,     json[1][:served]
  end

  test "logged-in and list orders for invalid table" do
    set_request_headers(@user)
    get :index, table_id: 0

    assert_response 422
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 1, json.keys.count
    assert json.key?(:errors)
    assert has_error_message(json[:errors], "table is invalid")
  end

  test "logged-out and cancel order" do
    set_request_headers # no authentication_token
    assert_no_difference 'Order.count' do
      delete :destroy, { table_id: @table.id, id: @pending_order.id }
    end

    assert_response 401
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 1, json.keys.count
    assert json.key?(:errors)
    assert has_error_message(json[:errors], "user is unauthorized")
  end

  test "logged-in and cancel order from valid table" do
    set_request_headers(@user)
    assert_not_nil @table.orders.find_by(id: @pending_order.id)
    assert_difference 'Order.count', -1 do
      delete :destroy, { table_id: @table.id, id: @pending_order.id }
    end

    assert_response 204
    json = parse_json_from(@response)
    assert json.empty?

    @table.reload
    assert_nil @table.orders.find_by(id: @pending_order.id)
  end

  test "logged-in and cancel order from invalid table" do
    set_request_headers(@user)
    assert_no_difference 'Order.count' do
      delete :destroy, { table_id: 0, id: @pending_order.id }
    end

    assert_response 422
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 1, json.keys.count
    assert json.key?(:errors)
    assert has_error_message(json[:errors], "table is invalid")
  end

  test "logged-in and cancel invalid order" do
    set_request_headers(@user)
    assert_no_difference 'Order.count' do
      delete :destroy, { table_id: @table.id, id: @other_order.id }
    end

    assert_response 422
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 1, json.keys.count
    assert json.key?(:errors)
    assert has_error_message(json[:errors], "order is invalid")
  end

end
