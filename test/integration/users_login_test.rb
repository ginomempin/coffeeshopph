require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  test "error-login with invalid email/password combination" do
    get login_path
    assert_template "sessions/new"
    post login_path, session: { email: "",
                                password: "" }
    assert_template "sessions/new"
    assert_select "div.alert-danger"
    assert_not flash.empty?
    assert_not flash[:danger].empty?

    # check that the flash does not persist
    get root_path
    assert_select "div.alert-danger", false, "flash message should not persist"
  end

end
