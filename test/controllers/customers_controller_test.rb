require 'test_helper'

class CustomersControllerTest < ActionController::TestCase

  test "should redirect create when not logged in" do
    assert_no_difference 'Customer.count' do
      post :create, table_id: tables(:table6).id
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Customer.count' do
      delete :destroy, id: customers(:customer1).id
    end
    assert_redirected_to login_url
  end

end
