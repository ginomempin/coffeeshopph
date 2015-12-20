require 'test_helper'

class API::APIControllerTest < ActionController::TestCase
  include APITestHelpers

  def setup
    @user = users(:user1)
  end

  test "should return the current user based on the authentication token" do
    set_request_headers(@user)
    assert_equal @controller.current_user.authentication_token, @user.authentication_token
  end

  test "should return nil current user when header has no authentication token" do
    set_request_headers
    assert @controller.current_user.nil?
  end

end
