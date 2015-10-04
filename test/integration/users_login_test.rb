require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    # get the test user from the test fixture user.yml
    @user = users(:admin1)
  end

  test "error-login with invalid credentials" do
    get login_path
    assert_template "sessions/new"
    check_log_in_as(@user, password: "wrong", remeber_me: "0")
    assert_template "sessions/new"
    assert_select "div.alert-danger"
    assert_not flash.empty?
    assert_not flash[:danger].empty?

    # check that the flash does not persist
    get root_path
    assert_select "div.alert-danger", false, "flash message should not persist"
  end

  test "success-login with valid credentials then logout" do
    # login
    get login_path
    assert_template "sessions/new"
    check_log_in_as(@user, password: "password", remeber_me: "0")
    assert check_logged_in?
    assert_redirected_to user_path(@user)
    follow_redirect!
    assert_template "users/show"
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path, count: 1
    assert_select "a[href=?]", user_path(@user), count: 1
    # logout
    delete logout_path
    assert_not check_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path, count: 1
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
    # logout again
    delete logout_path
    assert_not check_logged_in?
  end

  test "success-login with remembering" do
    check_log_in_as(@user, remember_me: "1")
    assert_not_nil cookies['remember_token']
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end

  test "success-login without remembering" do
    check_log_in_as(@user, remember_me: "0")
    assert_nil cookies['remember_token']
  end

end
