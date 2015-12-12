require 'test_helper'

class API::V1::UsersControllerTest < ActionController::TestCase

  def setup
    @request.headers['Accept'] = 'application/vnd.coffeeshop.v1'
    @request.headers['Content-Type'] = 'application/json'
    @user = users(:user1)
  end

  test "should return user as json" do
    get :show, id: @user.id, format: :json

    assert_response 200
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal @user.name,  json[:name]
    assert_equal @user.email, json[:email]
  end

  test "should return error as json when user is invalid" do
    get :show, id: 0, format: :json

    assert_response 422
    json = parse_json_from(@response)
    assert_not_nil json

    assert json.key?(:errors)
    assert_not json[:errors].empty?
    assert has_error_message(json[:errors], "user is invalid")
  end

end
