require 'test_helper'

class OrdersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin1 = users(:admin1)
    @order1 = orders(:order1)
  end

  test "should display list of orders" do
    #1. login
    check_log_in_as(@admin1)
    #2. access the orders page from the header
    get orders_path
    assert_template "orders/index"
    #3. check the displayed list of orders
    1.upto(5) do |n|
      assert_select "a.list-group-item", { text:  /Order #{n}$/,
                                           count: 1 }
      assert_select "span.badge", { text: "SERVED" }
    end
    6.upto(10) do |n|
      assert_select "a.list-group-item", { text:  /Order #{n}$/,
                                           count: 1 }
      assert_select "span.badge", { text: "PENDING" }
    end
  end

  test "should display order info" do
    #1. login
    check_log_in_as(@admin1)
    #2. access the tables info page
    get order_path(@order1.id)
    assert_template "orders/show"
    #3. check the contents of the page
    assert_select "h1", { text: @order1.name }
    if @order1.served?
      assert_select "span.label", { text: "SERVED" }
    else
      assert_select "span.label", { text: "PENDING" }
    end
    assert_select "li.list-group-item", { text: "PRICE: #{@order1.price}" }
    assert_select "li.list-group-item", { text: "QUANTITY: #{@order1.quantity}" }
  end

end
