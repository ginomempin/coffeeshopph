require 'test_helper'

class OrdersControllerTest < ActionController::TestCase

  test "should redirect index when not logged in" do
    get :index
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect show when not logged in" do
    get :show, id: 1
    assert_not flash.empty?
    assert_redirected_to login_url
  end

end
