require 'test_helper'

class UsersInfoTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:user1)
  end

  test "should display the User Info page" do
    #1. login
    check_log_in_as(@user)
    #2. access the User Info page
    get user_path(@user)
    assert_template 'users/show'
    #3. check the page header
    assert_select "h1", { text: @user.name }
    #4. check the user picture
    # Checking of the default user picture is done
    #  in the tests for user signup. Checking of
    #  updating the user picture is done in the
    #  tests for user edit info.
  end

  test "should display customer list if user is currently serving" do
    user = users(:user3)

    #1. login
    check_log_in_as(user)
    #2. access the User Info page
    get user_path(user)
    #3. check the list of customers
    assert_select 'div#customer-list>div.panel-heading', { text: "Customers: 3"}
    assert_not user.tables.empty?
    user.tables.each do |t|
      assert_select 'div.list-group>a.list-group-item[href=?]',
                    table_path(t),
                    { text: t.name }
    end
  end

  test "should not display customer list if user is not serving" do
    user = users(:user4)

    #1. login
    check_log_in_as(user)
    #2. access the User Info page
    get user_path(user)
    #3. check the list of customers
    assert_select 'div#customer-list>div.panel-heading', { text: "Customers: 0"}
    assert_select 'div.list-group>a.list-group-item', { count: 0 }
  end

end
