require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @sel_title = "title"
    @sel_header = "h1"
  end

  test "should get signup" do
    # check GETing the URL for the Sign Up page
    get :new
    assert_response :success
    # check the <title> tag
    assert_select @sel_title, "#{APP_NAME} | #{SIGNUP_PAGE_TITLE}"
    # check the page header
    assert_select @sel_header, SIGNUP_PAGE_HEADER
  end

end
