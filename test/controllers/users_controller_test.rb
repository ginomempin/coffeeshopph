require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @user1 = users(:user1)
    @user2 = users(:user2)
    @sel_title = "title"
    @sel_header = "h1"
  end

  test "should get signup form" do
    # check GETing the URL for the Sign Up page
    get :new
    assert_response :success
    # check the <title> tag
    assert_select @sel_title, "#{APP_NAME} | #{SIGNUP_PAGE_TITLE}"
    # check the page header
    assert_select @sel_header, SIGNUP_PAGE_HEADER
  end

  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to login_url
  end

  test "should redirect edit when not logged in" do
    get :edit, id: @user1.id
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as different user" do
    check_log_in_as(@user2)
    get :edit, id: @user1.id
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when not logged in" do
    patch :update, id: @user1.id, user: { name: @user1.name,
                                         email: @user1.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when logged in as different user" do
    check_log_in_as(@user2)
    patch :update, id: @user1.id, user: { name: @user1.name,
                                         email: @user1.email }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect delete when not logged in" do
    assert_no_difference "User.count" do
      delete :destroy, id: @user1.id
    end
    assert_redirected_to login_url
  end

  test "should redirect delete when logged-in as non-admin" do
    check_log_in_as(@user1)
    assert_no_difference "User.count" do
      delete :destroy, id: @user1.id
    end
    assert_redirected_to root_url
  end

end
