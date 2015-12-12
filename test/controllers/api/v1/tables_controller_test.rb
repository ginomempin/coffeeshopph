require 'test_helper'

class API::V1::TablesControllerTest < ActionController::TestCase

  def setup
    @request.headers['Accept'] = 'application/vnd.coffeeshop.v1'
    @table = tables(:table1)
  end

  test "should return table as json" do
    get :show, id: @table.id, format: :json

    assert_response 200
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal @table.name,        json[:name]
    assert_equal @table.max_persons, json[:max_persons]
    assert_equal @table.num_persons, json[:num_persons]
    assert_equal @table.occupied,    json[:occupied]
    assert_equal @table.total_bill,  json[:total_bill]
  end

end
