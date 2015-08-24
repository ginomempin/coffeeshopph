require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "error: invalid signup" do
    get signup_path
    assert_template "users/new"
    assert_no_difference 'User.count' do
      post users_path, user: { name: "",
                               email: "user@invalid",
                               password: "123",
                               password_confirmation: "456" }
    end
    assert_template "users/new"
  end

end
