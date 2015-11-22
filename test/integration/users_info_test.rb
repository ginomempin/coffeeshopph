require 'test_helper'

class UsersInfoTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:admin1)
  end

  test "should display the User Info page" do
    #1. login
    check_log_in_as(@user)
    #2. access the User Info page
    get user_path(@user)
    assert_template 'users/show'
    #3. check the page header
    assert_select "h1", { text: @user.name }
    #4. check the user picture
    # Checking of the default user picture is done
    #  in the tests for user signup. Checking of
    #  updating the user picture is done in the
    #  tests for user edit info.
  end

end
