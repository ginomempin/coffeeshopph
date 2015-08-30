require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

  def setup
    @sel_title = "title"
    @sel_header = "h1"
  end

  test "should get login" do
    # check GETing the URL for the Log In page
    get :new
    assert_response :success
    # check the <title> tag
    assert_select @sel_title, "#{APP_NAME} | #{LOGIN_PAGE_TITLE}"
    # check the page header
    assert_select @sel_header, LOGIN_PAGE_HEADER
  end

end
