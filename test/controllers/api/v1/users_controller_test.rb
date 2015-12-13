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

  test "should update user details and return the updated user as json" do
    old_updated_at = @user.updated_at
    patch :update, { id: @user.id,
                     user:
                     {
                       name: "New Name",
                       email: "newemail@test.com",
                     }
                   },
                   { format: :json }
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

  test "should update user password and return the updated user as json" do
    old_updated_at = @user.updated_at
    old_password_digest = @user.password_digest
    patch :update, { id: @user.id,
                     user:
                     {
                       password: "newpassword",
                       password_confirmation: "newpassword",
                     }
                   },
                   { format: :json }
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

  test "should return error as json when updating invalid user" do
    patch :update, { id: 0,
                     user:
                     {
                       name: "New Name",
                       email: "newemail@test.com"
                     }
                   },
                   { format: :json }

    assert_response 422
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 1, json.keys.count
    assert json.key?(:errors)
    assert has_error_message(json[:errors], "user is invalid")
  end

  test "should return error as json when updating user with bad details" do
    old_updated_at = @user.updated_at
    patch :update, { id: @user.id,
                     user:
                     {
                       name: "",
                       email: "invalid@email"
                     }
                   },
                   { format: :json }
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

  test "should return error as json when updating user with bad password" do
    old_updated_at = @user.updated_at
    patch :update, { id: @user.id,
                     user:
                     {
                       password: "45678",
                       password_confirmation: ""
                     }
                   },
                   { format: :json }
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

  test "should delete user and return an empty response" do
    assert_difference 'User.count', -1 do
      delete :destroy, { id: @user.id }, format: :json
    end

    assert_response 204
    json = parse_json_from(@response)
    assert json.empty?
  end

  test "should return error as json when deleting invalid user" do
    assert_no_difference 'User.count' do
      delete :destroy, { id: 0 }, format: :json
    end

    assert_response 422
    json = parse_json_from(@response)
    assert_not_nil json

    assert_equal 1, json.keys.count
    assert json.key?(:errors)
    assert has_error_message(json[:errors], "user is invalid")
  end

end
