require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  # These tests depends on the type and number of users that
  # are defined in the fixtures/users data file:
  # - at least 1 admin and 1 non-admin
  # - enough users for at least 3 pages
  def setup
    @admin1 = users(:admin1)
    @user1 = users(:user1)
  end

  test "should display list of users with pagination" do
    #1. log in
    check_log_in_as(@admin1)
    #2. access the Users page from the header
    get users_path
    assert_template "users/index"
    assert_select "div.pagination", { count: 2 }
    #3. check the displayed list of users
    assert_select "a.list-group-item", { text: /Test Admin|User \d+/,
                                         count: USERS_DEFAULT_PER_PAGE }
    assert_select "a.list-group-item" do
      assert_select "div.no-image"
      assert_select "span.badge"
    end
    #4. check pagination
    total_users = 52
    1.upto(3) do |n|
      get "/users?page=#{n}"
      assert_template "users/index"
      assert_select "div.pagination", { count: 2 }
      expected_users = (total_users > USERS_DEFAULT_PER_PAGE) ? USERS_DEFAULT_PER_PAGE : total_users
      assert_select "a.list-group-item", { count: expected_users }
      total_users -= USERS_DEFAULT_PER_PAGE
    end
  end

  test "should allow delete for admin" do
    #1. log in
    check_log_in_as(@admin1)
    #2. access the Users page from the header
    get users_path
    #3. check for delete links (only the logged-in user has no delete link)
    assert_select "a.list-actions-danger", { text: "Delete",
                                             minimum: USERS_DEFAULT_PER_PAGE-1,
                                             maximum: USERS_DEFAULT_PER_PAGE }
    #4. delete a user
    assert_difference "User.count", -1 do
      delete user_path(@user1)
    end
  end

  test "should not allow delete for non-admin" do
    #1. log in
    check_log_in_as(@user1)
    #2. access the Users page from the header
    get users_path
    #3. check that there are no delete links
    assert_select "a.list-actions-danger", { text: "Delete",
                                             count: 0 }
    #4. delete a user

  end

end
