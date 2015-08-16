require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @sel_title = "title"
    @sel_header = "h1"
  end

  test "should get login" do
    # check GETing the URL for the Home page
    get :login
    assert_response :success
    # check the <title> tag
    assert_select @sel_title, "#{APP_NAME} | #{PAGE_LOGIN_NAME}"
    # check the page header
    assert_select @sel_header, PAGE_LOGIN_NAME
  end

  test "should get signup" do
    # check GETing the URL for the Home page
    get :new
    assert_response :success
    # check the <title> tag
    assert_select @sel_title, "#{APP_NAME} | #{PAGE_SIGNUP_NAME}"
    # check the page header
    assert_select @sel_header, PAGE_SIGNUP_NAME
  end

end
