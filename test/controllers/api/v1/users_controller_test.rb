require 'test_helper'

class API::V1::UsersControllerTest < ActionController::TestCase

  def setup
    @request.headers['Accept'] = 'application/vnd.coffeeshop.v1'
    @request.headers['Content-Type'] = 'application/json'
    @user = users(:user3)
  end

  test "should return user as json" do
    get :show, id: @user.id, format: :json

    assert_response 200
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 3, json.keys.count
    assert_equal @user.name,          json[:name]
    assert_equal @user.email,         json[:email]
    assert_equal @user.tables.count,  json[:tables].count
    json[:tables].each do |table|
      assert_equal 1, table.keys.count
    end
  end

  test "should return error as json when user is invalid" do
    get :show, id: 0, format: :json

    assert_response 422
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 1, json.keys.count
    assert json.key?(:errors)
    assert has_error_message(json[:errors], "user is invalid")
  end

end
