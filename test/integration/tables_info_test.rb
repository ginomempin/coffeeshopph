require 'test_helper'

class TablesInfoTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:admin1)

    # occupied, has a server, has 3 orders
    @table1 = tables(:table1)

    # unoccupied, no server, no orders
    @table6 = tables(:table6)
  end

  test "should display the table info page" do
    #1. login
    check_log_in_as(@user)
    #2. access the Table Info page
    get table_path(@table1.id)
    assert_template "tables/show"
    assert_select "h1", { text: @table1.name }
    #3. check that there is a table details panel
    assert_select "div.panel#table-details", { count: 1 }
    #4. check that there is an add order panel
    assert_select "div.panel#add-order", { count: 1 }
    #5. check that there is an order list panel
    assert_select "div.panel#order-list", { count: 1 }
  end

  test "should display the table person count" do
    #1. login
    check_log_in_as(@user)
    #2. access the Table Info page
    get table_path(@table1.id)
    assert_select "div.panel#table-details" do
      assert_select "span", { text: "MAX:" }
      assert_select "span.badge", { text: "4" }
      assert_select "span", { text: "NOW:" }
      assert_select "span.badge", { text: "2" }
    end
  end

  test "should show if table is occupied or free" do
    #1. login
    check_log_in_as(@user)
    #2. access Table Info page for occupied table
    get table_path(@table1.id)
    assert_select "span.label", { text: "OCCUPIED" }
    #3. access Table Info page for unoccupied table
    get table_path(@table6.id)
    assert_select "span.label", { text: "FREE" }
  end

  test "should show the table's server if occupied" do
    #1. login
    check_log_in_as(@user)
    #2. access Table Info page for occupied table
    get table_path(@table1.id)
    assert_select 'div>a', { text: @table1.server.name }
    assert_select 'div>a[href=?]', user_path(@table1.server)
    #3. access Table Info page for unoccupied table
    get table_path(@table6.id)
    assert_select 'div', { text: "SERVER:", count: 0 }
  end

  test "should show a list of orders for an occupied table" do
    #1. login
    check_log_in_as(@user)
    #2. access the Table Info page for an occupied table
    get table_path(@table1.id)
    #3. check the order count
    assert_select "div.panel-heading", { text: "Orders: 3" }
    #4. check the order list
    assert_not @table1.orders.empty?
    @table1.orders.each do |order|
      assert_select "span.label", { text: (order.served ? "SERVED" : "PENDING") }
      assert_select "li.list-group-item>span.name",
                    { text: order.name, count: 1 }
      assert_select "li.list-group-item>span.total",
                    { text: "#{order.price}, #{order.quantity}",
                      count: 1 }
    end
  end

  test "should show a placeholder text for an unoccupied table" do
    #1. login
    check_log_in_as(@user)
    #2. access the Table Info page for an occupied table
    get table_path(@table6.id)
    #3. check the order count
    assert_select "div.panel-heading", { text: "Orders: 0" }
    #4. check the order list
    assert_select "p", { text: "This table has no orders." }
  end

  test "should allow add and delete orders from table info page" do
    #1. access the Table Info page
    check_log_in_as(@user)
    get table_path(@table1.id)
    assert_template 'tables/show'
    #2. add an order with invalid details
    assert_no_difference 'Order.count' do
      post orders_path, order: { name: "",
                                 price: 150.75,
                                 quantity: 0,
                                 table_id: @table1.id }
    end
    assert_equal 3, @table1.orders.count
    assert_template 'tables/show'
    assert_select 'div#error_explanation'
    assert_select 'div#error_explanation>div.alert-danger', text: /2 errors/
    assert_select 'div#error_explanation>ul>li', count: 2
    assert_select 'div.field_with_errors', count: 4
    #3. add an order with valid details
    assert_difference 'Order.count', 1 do
      post orders_path, order: { name: "New Order",
                                 price: 150.75,
                                 quantity: 1,
                                 table_id: @table1.id }
    end
    assert_equal 4, @table1.reload.orders.count
    assert_not flash.empty?
    assert_redirected_to table_path(@table1.id)
    #4. check that the new order is now visible on the page
    follow_redirect!
    assert_match 'New Order', response.body
    #5. check that the new order is cancellable
    new_order = @table1.orders.find_by(name: "New Order")
    assert_select 'a[href=?]', order_path(id: new_order.id,
                                          table_id: new_order.table_id),
                               text: "Cancel Order"
    #6. cancel the new order
    assert_difference 'Order.count', -1 do
      delete order_path(id: new_order.id,
                        table_id: new_order.table_id)
    end
    assert_equal 3, @table1.reload.orders.count
    assert_not flash.empty?
    assert_redirected_to table_path(@table1.id)
  end

  test "should clear and occupy a table" do
    # fixture data
    customer2 = customers(:customer2)
    user3 = users(:user3)
    table2 = tables(:table2)
    assert user3.serving?(table2)

    #1. access the Table Info page
    check_log_in_as(user3)
    get table_path(table2.id)
    assert_template 'tables/show'
    assert_select "input[type=submit][value=Clear]"
    assert_select "span.label", { text: "OCCUPIED" }
    assert_select "div.panel-heading", { text: "Orders: 2" }
    #2. clear the table
    assert_difference 'Customer.count', -1 do
      delete customer_path(customer2.id)
    end
    #3. check redirection back to the Table Info Page
    assert_redirected_to table_path(table2.id)
    follow_redirect!
    #4. check that the page is now updated
    assert_select "input[type=submit][value=Occupy]"
    assert_select "span.label", { text: "FREE" }
    assert_select "div.panel-heading", { text: "Orders: 0" }
    #5. check the User model
    user3.reload
    assert_not user3.serving?(table2)
    #6. check the Table model
    table2.reload
    assert_nil table2.server
    assert table2.orders.empty?
    #7. occupy the table
    assert_difference 'Customer.count', 1 do
      post customers_path, { server_id: user3.id,
                             table_id: table2.id }
    end
    #8. check redirection back to the Table Info Page
    assert_redirected_to table_path(table2.id)
    follow_redirect!
    #9. check that the page is now updated
    assert_select "input[type=submit][value=Clear]"
    assert_select "span.label", { text: "OCCUPIED" }
    assert_select "div.panel-heading", { text: "Orders: 0" }
    #10. check the User model
    user3.reload
    assert user3.serving?(table2)
  end

end
