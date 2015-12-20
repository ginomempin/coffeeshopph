require 'test_helper'

class API::V1::SessionsControllerTest < ActionController::TestCase
  include APITestHelpers

  def setup
    @active_user = users(:user1)
    @inactive_user = users(:user51)
    set_request_headers
  end

  test "should return user as json when signing-in with correct and activated credentials" do
    old_token = @active_user.authentication_token
    credentials = { email: @active_user.email, password: 'password' }
    post :create, session: credentials

    assert_response 200
    json = parse_json_from(@response)
    assert_not_nil json

    @active_user.reload
    new_token = @active_user.authentication_token
    assert_not_equal old_token, new_token
    assert_equal 2, json.keys.count
    assert_equal @active_user.name,                 json[:name]
    assert_equal @active_user.authentication_token, json[:authentication_token]
  end

  test "should return error as json when signing-in with correct but inactivated credentials" do
    credentials = { email: @inactive_user.email, password: 'password' }
    post :create, session: credentials

    assert_response 401
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 1, json.keys.count
    assert json.key?(:errors)
    assert has_error_message(json[:errors], "this account is not yet activated")
  end

  test "should return error as json when signing-in with incorrect credentials" do
    credentials = { email: @active_user.email, password: 'wrong' }
    post :create, session: credentials

    assert_response 422
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 1, json.keys.count
    assert json.key?(:errors)
    assert has_error_message(json[:errors], "invalid email or password")
  end

  test "should expire tokens and return nothing when signing-out a user" do
    old_token = @active_user.authentication_token
    delete :destroy, { id: old_token }

    assert_response 204
    json = parse_json_from(@response)
    assert json.empty?

    @active_user.reload
    new_token = @active_user.authentication_token
    assert_not_equal old_token, new_token
  end

end
