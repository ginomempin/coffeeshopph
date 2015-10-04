require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:admin1)
    remember(@user)
  end

  test "success-current_user returns the right user when session[:user_id] is nil" do
    assert_equal @user, current_user
    assert check_logged_in?
  end

  test "success-current_user returns nil when the remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.token))
    assert_nil current_user
  end

end
