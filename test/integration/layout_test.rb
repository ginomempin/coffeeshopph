require 'test_helper'

class LayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user1 = users(:user1)
  end

  test "display links for non-logged-in users" do
    get root_path
    assert_template "static_pages/home"
    # header links
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", about_path, count: 1
    assert_select "a[href=?]", help_path, count: 1
    assert_select "a[href=?]", login_path, count: 1
    # body/common links
    assert_select "a[href=?]", tables_path, count: 1
    # footer links
    assert_select "a[href=?]", contact_path, count: 1
  end

  test "display links for logged-in users" do
    check_log_in_as(@user1)
    get root_path
    # header links
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", about_path, count: 1
    assert_select "a[href=?]", help_path, count: 1
    assert_select "a[href=?]", user_path(@user1), count: 1
    assert_select "a[href=?]", edit_user_path(@user1), count: 1
    assert_select "a[href=?]", users_path, count: 1
    assert_select "a[href=?]", logout_path, count: 1
    # body/common links
    assert_select "a[href=?]", tables_path, count: 2
    # footer links
    assert_select "a[href=?]", contact_path, count: 1
  end

  test "display links from login page" do
    get login_path
    assert_template "sessions/new"
    assert_select "a[href=?]", signup_path, count: 1
  end

end
