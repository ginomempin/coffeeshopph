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
      post users_path, user: { name: "New User",
                               email: "userXYZ@test.com",
                               password: "abc123",
                               password_confirmation: "abc123" }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?

    # attempt to login before activation
    check_log_in_as(user)
    assert_not check_logged_in?

    # other existing users should not see this unactivated user
    check_log_in_as(users(:admin1))
    # -- users list (count based on fixtures)
    1.upto(3) do |n|
      get users_path, page: "#{n}"
      assert_no_match user.name, response.body
    end
    # -- profile page
    get user_path(user)
    assert_redirected_to root_url
    # logout the current user
    delete logout_path

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

    # check that the default user info page has no picture
    assert_not assigns(:user).picture?
    assert_select "div.no-image"
  end

end
