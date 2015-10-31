require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:admin1)
  end

  test "password resets" do
    # visit the Password Reset form
    get new_password_reset_path
    assert_template "password_resets/new"

    # provide an invalid email
    post password_resets_path, password_reset: { email: "invalid@email.com" }
    assert_not flash.empty?
    assert_template "password_resets/new"
    # provide a valid email
    post password_resets_path, password_reset: { email: @user.email }
    assert_not_equal @user.password_reset_digest, @user.reload.password_reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url

    # get the @user instance variable from the view/controller
    user = assigns(:user)

    # click on the password reset link with an invalid email
    get edit_password_reset_path(user.password_reset_token, email: "invalid@email.com")
    assert_redirected_to root_url

    # click on the password reset link of an inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.password_reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)

    # click on the password reset link with a valid email but an invalid token
    get edit_password_reset_path("invalid token", email: user.email)
    assert_redirected_to root_url

    # click on the password reset link with a valid email and a valid token
    get edit_password_reset_path(user.password_reset_token, email: user.email)
    assert_template "password_resets/edit"
    assert_select "input[name=email][type=hidden][value=?]", user.email

    # submit a mismatched password and password confirmation
    patch password_reset_path(user.password_reset_token),
          email: user.email,
          user: { password:              "abcdef",
                  password_confirmation: "123456" }
    assert_select "div#error_explanation"
    assert_template "password_resets/edit"

    # submit an empty password
    patch password_reset_path(user.password_reset_token),
          email: user.email,
          user: { password:              "",
                  password_confirmation: "" }
    assert_select "div#error_explanation"
    assert_template "password_resets/edit"

    # submit a valid password combination
    patch password_reset_path(user.password_reset_token),
          email: user.email,
          user: { password:              "123456",
                  password_confirmation: "123456" }
    assert_not flash.empty?
    assert check_logged_in?
    assert_redirected_to user_url(user)

  end

end
