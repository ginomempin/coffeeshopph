require 'test_helper'

class API::V1::TablesControllerTest < ActionController::TestCase
  include APITestHelpers

  def setup
    @user = users(:user1)
    @table = tables(:table1)
  end

  test "logged-out and show table" do
    set_request_headers # no authentication token
    get :show, id: @table.id

    assert_response 401
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 1, json.keys.count
    assert json.key?(:errors)
    assert has_error_message(json[:errors], "user is unauthorized")
  end

  test "logged-in and show valid table" do
    set_request_headers(@user)
    get :show, id: @table.id

    assert_response 200
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 7, json.keys.count
    assert_equal @table.name,           json[:name]
    assert_equal @table.max_persons,    json[:max_persons]
    assert_equal @table.num_persons,    json[:num_persons]
    assert_equal @table.occupied,       json[:occupied]
    assert_equal @table.total_bill,     json[:total_bill]
    assert_equal @table.orders.count,   json[:orders].count
    json[:orders].each do |order|
      assert_equal 3, order.keys.count
    end
    assert_equal @table.server.name,    json[:server][:name]
    assert_equal 1,                     json[:server].keys.count
  end

  test "logged-in and show invalid table" do
    set_request_headers(@user)
    get :show, id: 0

    assert_response 422
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 1, json.keys.count
    assert json.key?(:errors)
    assert has_error_message(json[:errors], "table is invalid")
  end

end
