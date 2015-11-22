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
    check_log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    new_name = "Test Admin 1 EDITED"
    new_email = "admin1_edited@test.com"
    assert_no_difference "User.count" do
      # blank passwords should be OK since users
      #  shouldn't be required to also update their
      #  passwords when updating their profile
      patch user_path(@user), user: { name:  new_name,
                                      email: new_email,
                                      password: "",
                                      password_confirmation: "" }
    end
    assert_not flash.empty?
    assert_redirected_to user_path(@user)
    # fetch the updated user from the database
    @user.reload
    assert_equal @user.name, new_name
    assert_equal @user.email, new_email
  end

  test "successful edit of profile picture" do
    #1. login
    check_log_in_as(@user)
    #2. access the Edit Profile page
    get edit_user_path(@user)
    assert_template "users/edit"
    #3. check for an image file upload field
    assert_select "input[type=file]"
    #4. upload a test profile picture
    picture = fixture_file_upload("test/fixtures/test_user_picture.jpg", "image/png")
    #5. save changes
    assert_no_difference "User.count" do
      patch user_path(@user), user: { name: @user.name,
                                      email: @user.email,
                                      password: "",
                                      password_confirmation: "",
                                      picture: picture }
    end
    #6. check that the User Info page now displays a user picture
    assert_not flash.empty?
    assert_redirected_to user_path(@user)
    follow_redirect!
    assert assigns(:user).picture?
    assert_select "img#user-image"

    #7. check that the Users List page also displays the user picture
    #note: it is assumed here that the updated user is on the first page
    get users_path
    assert_select "a[href=?]", user_path(@user) do
      assert_select "img#user-image"
    end
  end

end
