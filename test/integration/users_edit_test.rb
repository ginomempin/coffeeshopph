require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:user1)
  end

  test "unsuccessful edit" do
    get edit_user_path(@user)
    assert_template "users/edit"
    patch user_path(@user), user: { name:  "",
                                    email: "invalid@email",
                                    password: "abc123",
                                    password_confirmation: "def456" }
    assert_template "users/edit"
  end

  test "successful edit" do
    get edit_user_path(@user)
    assert_template "users/edit"
    new_name = "Test User 1 EDITED"
    new_email = "user1_edited@test.com"
    # blank passwords should be OK
    # since users don't update their passwords often
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
