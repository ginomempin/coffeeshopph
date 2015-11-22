require 'test_helper'

class OrdersInfoTest < ActionDispatch::IntegrationTest

  def setup
    @admin1 = users(:admin1)
    @order1 = orders(:order1)
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
    assert_select "li.list-group-item", { text: "Table: #{@order1.table.name}" }
    assert_select "a[href=?]", table_path(@order1.table.id)
    assert_select "li.list-group-item", { text: "Price: #{@order1.price}" }
    assert_select "li.list-group-item", { text: "Quantity: #{@order1.quantity}" }
  end

end
