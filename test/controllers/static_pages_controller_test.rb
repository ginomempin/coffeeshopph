require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase

  def setup
    @base_title = "CoffeeShop | "
    @sel_title = "title"
    @sel_header = "h1"
  end

  test "should get home" do
    # check GETing the URL for the Home page
    get :home
    assert_response :success
    # check the <title> tag
    assert_select @sel_title, "#{@base_title}Home"
    # check the page header
    assert_select @sel_header, "CoffeeShop"
  end

  test "should get help" do
    # check GETing the URL for the Help page
    get :help
    assert_response :success
    # check the <title> tag
    assert_select @sel_title, "#{@base_title}FAQ"
    # check the page header
    assert_select @sel_header, "FAQ"
  end

  test "should get about" do
    # check GETing the URL for the About page
    get :about
    assert_response :success
    # check the <title> tag
    assert_select @sel_title, "#{@base_title}About"
    # check the page header
    assert_select @sel_header, "About"
  end

  test "should get contact" do
    # check GETing the URL for the Contact page
    get :contact
    assert_response :success
    # check the <title> tag
    assert_select @sel_title, "#{@base_title}Contact Us"
    # check the page header
    assert_select @sel_header, "Contact Us"
  end

end
