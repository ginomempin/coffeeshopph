require 'test_helper'

class LayoutTest < ActionDispatch::IntegrationTest

  test "links_from_home" do
    get root_path
    assert_template "static_pages/home"
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", about_path, count: 1
    assert_select "a[href=?]", help_path, count: 1
    assert_select "a[href=?]", contact_path, count: 1
    assert_select "a[href=?]", login_path, count: 1
  end

  test "links_from_login" do
    get login_path
    assert_template "sessions/new"
    assert_select "a[href=?]", signup_path, count: 1
  end

end
