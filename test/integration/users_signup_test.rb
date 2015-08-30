require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "error: invalid signup" do
    get signup_path
    assert_template "users/new"
    assert_no_difference 'User.count' do
      post users_path, user: { name: "",
                               email: "user@invalid",
                               password: "123",
                               password_confirmation: "456" }
    end
    assert_template "users/new"
    assert_select "div#error_explanation"
    assert_select "div.alert-danger", text:/4 errors/
    assert_select "div.field_with_errors", count:8
  end

  test "success: valid signup" do
    get signup_path
    assert_template "users/new"
    assert_difference 'User.count',1 do
      post_via_redirect users_path, user: { name: "Test User",
                                            email: "user@test.com",
                                            password: "abc123",
                                            password_confirmation: "abc123" }
    end
    assert_template "users/show"
  end

end
