require 'test_helper'

class API::V1::TablesControllerTest < ActionController::TestCase

  def setup
    @request.headers['Accept'] = 'application/vnd.coffeeshop.v1'
    @request.headers['Content-Type'] = 'application/json'
    @table = tables(:table1)
  end

  test "should return table as json" do
    get :show, id: @table.id, format: :json

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

  test "should return error as json when table is invalid" do
    get :show, id: 0, format: :json

    assert_response 422
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 1, json.keys.count
    assert json.key?(:errors)
    assert has_error_message(json[:errors], "table is invalid")
  end

end
