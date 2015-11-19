require 'test_helper'

class TablesInfoTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:admin1)
    @table = tables(:table1)
  end

  test "should display table info" do
    #1. login
    check_log_in_as(@user)
    #2. access the tables info page
    get table_path(@table.id)
    assert_template "tables/show"
    #3. check the contents of the page
    assert_select "h1", { text: @table.name }
    assert_select "span.badge",
                  { text: "#{@table.max_persons}",
                    count: 1 }
    assert_select "span.badge",
                  { text: "#{@table.num_persons}",
                    count: 1 }
    if @table.occupied?
      assert_select "span.label", { text: "OCCUPIED" }
    else
      assert_select "span.label", { text: "FREE" }
    end
    assert_select "div.panel-heading",
                  { text: "Orders: #{@table.orders.count}" }
    @table.orders.each do |order|
      if order.served?
        assert_select "span.label", { text: "SERVED" }
      else
        assert_select "span.label", { text: "PENDING" }
      end
      assert_select "li.list-group-item>span.name",
                    { text: order.name, count: 1 }
      assert_select "li.list-group-item>span.total",
                    { text: "#{order.price}, #{order.quantity}",
                      count: 1 }
    end
  end

  test "should add and delete orders from table info page" do
    #1. access the Table Info page
    check_log_in_as(@user)
    get table_path(@table.id)
    assert_template 'tables/show'
    #2. add an order with invalid details
    assert_no_difference 'Order.count' do
      post orders_path, order: { name: "",
                                 price: 150.75,
                                 quantity: 0,
                                 table_id: @table.id }
    end
    assert_equal 3, @table.orders.count
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
                                 table_id: @table.id }
    end
    assert_equal 4, @table.reload.orders.count
    assert_not flash.empty?
    assert_redirected_to table_path(@table.id)
    #4. check that the new order is now visible on the page
    follow_redirect!
    assert_match 'New Order', response.body
    #5. check that the new order is cancellable
    new_order = @table.orders.find_by(name: "New Order")
    assert_select 'a[href=?]', order_path(id: new_order.id,
                                          table_id: new_order.table_id),
                               text: "Cancel Order"
    #6. cancel the new order
    assert_difference 'Order.count', -1 do
      delete order_path(id: new_order.id,
                        table_id: new_order.table_id)
    end
    assert_equal 3, @table.reload.orders.count
    assert_not flash.empty?
    assert_redirected_to table_path(@table.id)
  end

end
