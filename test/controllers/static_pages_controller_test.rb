require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase

  def setup
    @sel_title = "title"
    @sel_header = "h1"
  end

  test "should get home" do
    # check GETing the URL for the Home page
    get :home
    assert_response :success
    # check the <title> tag
    assert_select @sel_title, APP_NAME
    # check the page header
    assert_select @sel_header, APP_NAME
  end

  test "should get help" do
    # check GETing the URL for the Help page
    get :help
    assert_response :success
    # check the <title> tag
    assert_select @sel_title, "#{APP_NAME} | #{PAGE_HELP_NAME}"
    # check the page header
    assert_select @sel_header, PAGE_HELP_NAME
  end

  test "should get about" do
    # check GETing the URL for the About page
    get :about
    assert_response :success
    # check the <title> tag
    assert_select @sel_title, "#{APP_NAME} | #{PAGE_ABOUT_NAME}"
    # check the page header
    assert_select @sel_header, PAGE_ABOUT_NAME
  end

  test "should get contact" do
    # check GETing the URL for the Contact page
    get :contact
    assert_response :success
    # check the <title> tag
    assert_select @sel_title, "#{APP_NAME} | #{PAGE_CONTACT_NAME}"
    # check the page header
    assert_select @sel_header, PAGE_CONTACT_NAME
  end

end
