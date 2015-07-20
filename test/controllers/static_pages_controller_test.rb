require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase

  test "should get home" do
    # check GETing the URL for the Home page
    get :home
    assert_response :success
    # check the <title> tag
    assert_select "title", "CoffeeShop | Home"
    # check the page header
    assert_select "h1", "CoffeeShop"
  end

  test "should get help" do
    # check GETing the URL for the Help page
    get :help
    assert_response :success
    # check the <title> tag
    assert_select "title", "CoffeeShop | Help"
    # check the page header
    assert_select "h1", "Help"
  end

  test "should get about" do
    # check GETing the URL for the About page
    get :about
    assert_response :success
    # check the <title> tag
    assert_select "title", "CoffeeShop | About"
    # check the page header
    assert_select "h1", "About"
  end

  test "should get contact" do
    # check GETing the URL for the Contact page
    get :contact
    assert_response :success
    # check the <title> tag
    assert_select "title", "CoffeeShop | Contact Us"
    # check the page header
    assert_select "h1", "Contact Us"
  end

end
