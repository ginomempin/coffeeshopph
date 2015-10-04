require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:admin1)
  end

  # This test depends on the number of users defined in the
  # fixtures/users data, which should be enough for at least
  # 3 pages.
  test "should display list of users with pagination" do
    #1. log in
    check_log_in_as(@user)
    #2. access the Users page from the header
    get users_path
    assert_template "users/index"
    assert_select "div.pagination", { count: 2 }
    #3. check the initially displayed page of users
    assert_select "a.list-group-item", { text: /Test Admin|User \d+/,
                                         count: USERS_DEFAULT_PER_PAGE }
    assert_select "a.list-group-item" do
      assert_select "img.gravatar"
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

end
