require 'test_helper'

class OrdersControllerTest < ActionController::TestCase

  def setup
    @order = orders(:order1)
  end

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

  test "should redirect create when not logged in" do
    assert_no_difference 'Order.count' do
      post :create, order: { name: @order.name,
                             price: @order.price,
                             quantity: @order.quantity,
                             served: false,
                             table_id: @order.table }
    end
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect delete when not logged in" do
    assert_no_difference 'Order.count' do
      delete :destroy, id: @order.id
    end
    assert_not flash.empty?
    assert_redirected_to login_url
  end

end
