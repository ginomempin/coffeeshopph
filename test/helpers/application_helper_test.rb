require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  test "format_tab_title" do
    assert_equal format_tab_title,          APP_NAME
    assert_equal format_tab_title(""),      APP_NAME
    assert_equal format_tab_title("About"), "#{APP_NAME} | About"
  end

  test "format_page_header" do
    assert_equal format_page_header,          APP_NAME
    assert_equal format_page_header(""),      APP_NAME
    assert_equal format_page_header("About"), "About"
  end

end
