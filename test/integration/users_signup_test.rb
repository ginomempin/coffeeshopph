require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "should fail for invalid signup" do
    get signup_path
    assert_template "users/new"
    assert_no_difference 'User.count' do
      post users_path, user: { name: "",
                               email: "user@invalid",
                               password: "123",
                               password_confirmation: "456" }
    end
    assert_template "users/new"
    assert_select "div#error_explanation"
    assert_select "div.alert-danger", text:/4 errors/
    assert_select "div.field_with_errors", count:8
  end

  test "should succeed with valid signup and account activation" do
    get signup_path
    assert_template "users/new"
    assert_difference 'User.count',1 do
      post users_path, user: { name: "Test User",
                               email: "user@test.com",
                               password: "abc123",
                               password_confirmation: "abc123" }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # attempt to login before activation
    check_log_in_as(user)
    assert_not check_logged_in?
    # attempt to activate with invalid token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not check_logged_in?
    # attempt to activate with invalid email
    get edit_account_activation_path(user.activation_token, email: "invalid email")
    assert_not check_logged_in?
    # attempt to activate with valid token and email
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template "users/show"
    assert check_logged_in?
  end

end
