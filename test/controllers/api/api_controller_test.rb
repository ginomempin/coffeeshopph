require 'test_helper'

class API::APIControllerTest < ActionController::TestCase
  include APITestHelpers

  def setup
    @user = users(:user1)
    set_request_headers(@user)
  end

  test "should return the current_user" do
    assert_equal @controller.current_user.authentication_token, @user.authentication_token
  end

end
