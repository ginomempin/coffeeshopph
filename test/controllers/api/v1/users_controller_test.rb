require 'test_helper'

class API::V1::UsersControllerTest < ActionController::TestCase
  include APITestHelpers

  def setup
    @user = users(:user3)
    @other_user = users(:user5)
  end

  test "logged-out and show user" do
    set_request_headers # no authentication token
    get :show, id: @user.id

    assert_response 401
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 1, json.keys.count
    assert json.key?(:errors)
    assert has_error_message(json[:errors], "user is unauthorized")
  end

  test "logged-in and show valid user" do
    set_request_headers(@user)
    get :show, id: @user.id

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

  test "logged-in and show invalid user" do
    set_request_headers(@user)
    get :show, id: 0

    assert_response 422
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 1, json.keys.count
    assert json.key?(:errors)
    assert has_error_message(json[:errors], "user is invalid")
  end

  test "logged-out and update user" do
    set_request_headers # no authentication token
    patch :update, id: @user.id,
                   user: { name:  "New Name",
                           email: "newemail@test.com"
                         }
    @user.reload

    assert_response 401
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 1, json.keys.count
    assert json.key?(:errors)
    assert has_error_message(json[:errors], "user is unauthorized")
  end

  test "logged-in and update user details" do
    set_request_headers(@user)
    old_updated_at = @user.updated_at
    patch :update, id: @user.id,
                   user: { name:  "New Name",
                           email: "newemail@test.com"
                         }
    @user.reload

    assert_response 200
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 3, json.keys.count
    assert_equal "New Name",          json[:name]
    assert_equal "newemail@test.com", json[:email]
    assert_equal @user.tables.count,  json[:tables].count

    assert_not_equal old_updated_at, @user.updated_at
  end

  test "logged-in and update user password" do
    set_request_headers(@user)
    old_updated_at = @user.updated_at
    old_password_digest = @user.password_digest
    patch :update, id: @user.id,
                   user: { password:              "newpassword",
                           password_confirmation: "newpassword"
                         }
    @user.reload

    assert_response 200
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 3, json.keys.count
    assert_equal @user.name,         json[:name]
    assert_equal @user.email,        json[:email]
    assert_equal @user.tables.count, json[:tables].count

    assert_not_equal old_updated_at, @user.updated_at
    assert_not_equal old_password_digest, @user.password_digest
  end

  test "logged-in and update invalid user" do
    set_request_headers(@user)
    patch :update, id: 0,
                   user: { name:  "New Name",
                           email: "newemail@test.com"
                         }

    assert_response 422
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 1, json.keys.count
    assert json.key?(:errors)
    assert has_error_message(json[:errors], "user is invalid")
  end

  test "logged-in and update other user" do
    set_request_headers(@user)
    patch :update, id: @other_user.id,
                   user: { name:  "New Name",
                           email: "newemail@test.com"
                         }

    assert_response 401
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 1, json.keys.count
    assert json.key?(:errors)
    assert has_error_message(json[:errors], "user is unauthorized")
  end

  test "logged-in and update user with bad details" do
    set_request_headers(@user)
    old_updated_at = @user.updated_at
    patch :update, id: @user.id,
                   user: { name:  "",
                           email: "invalid@email"
                         }
    @user.reload

    assert_response 422
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 1, json.keys.count
    assert json.key?(:errors)
    assert has_error_message(json[:errors], "name can't be blank")
    assert has_error_message(json[:errors], "email format does not appear to be valid")

    assert_equal old_updated_at, @user.updated_at
  end

  test "logged-in and update user with bad password" do
    set_request_headers(@user)
    old_updated_at = @user.updated_at
    patch :update, id: @user.id,
                   user: { password:              "45678",
                           password_confirmation: ""
                         }
    @user.reload

    assert_response 422
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 1, json.keys.count
    assert json.key?(:errors)
    assert has_error_message(json[:errors], "password confirmation doesn't match password")
    assert has_error_message(json[:errors], "password is too short")

    assert_equal old_updated_at, @user.updated_at
  end

  test "logged-out and delete user" do
    set_request_headers # no authentication token
    assert_no_difference 'User.count' do
      delete :destroy, id: @user.id
    end

    assert_response 401
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 1, json.keys.count
    assert json.key?(:errors)
    assert has_error_message(json[:errors], "user is unauthorized")
  end

  test "logged-in and delete user" do
    set_request_headers(@user)
    assert_difference 'User.count', -1 do
      delete :destroy, id: @user.id
    end

    assert_response 204
    json = parse_json_from(@response)
    assert json.empty?
  end

  test "logged-in and delete invalid user" do
    set_request_headers(@user)
    assert_no_difference 'User.count' do
      delete :destroy, id: 0
    end

    assert_response 422
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 1, json.keys.count
    assert json.key?(:errors)
    assert has_error_message(json[:errors], "user is invalid")
  end

  test "logged-in and delete other user" do
    set_request_headers(@user)
    assert_no_difference 'User.count' do
      delete :destroy, id: @other_user.id
    end

    assert_response 401
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 1, json.keys.count
    assert json.key?(:errors)
    assert has_error_message(json[:errors], "user is unauthorized")
  end

end
