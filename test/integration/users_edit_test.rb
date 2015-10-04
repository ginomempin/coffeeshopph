require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:admin1)
  end

  test "unsuccessful edit" do
    check_log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    patch user_path(@user), user: { name:  "",
                                    email: "invalid@email",
                                    password: "abc123",
                                    password_confirmation: "def456" }
    assert_template "users/edit"
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    check_log_in_as(@user)
    # expect to be forwarded to the original page being accessed
    assert_redirected_to edit_user_path(@user)
    new_name = "Test Admin 1 EDITED"
    new_email = "admin1_edited@test.com"
    # blank passwords should be OK since users
    #  shouldn't be required to also update their
    #  passwords when updating their profile
    patch user_path(@user), user: { name:  new_name,
                                    email: new_email,
                                    password: "",
                                    password_confirmation: "" }
    assert_not flash.empty?
    assert_redirected_to user_path(@user)
    # fetch the updated user from the database
    @user.reload
    assert_equal @user.name, new_name
    assert_equal @user.email, new_email
  end

end
