require 'test_helper'

class TablesInfoTest < ActionDispatch::IntegrationTest

  def setup
    @admin1 = users(:admin1)
    @table1 = tables(:table1)
  end

  test "should display table info" do
    #1. login
    check_log_in_as(@admin1)
    #2. access the tables info page
    get table_path(@table1.id)
    assert_template "tables/show"
    #3. check the contents of the page
    assert_select "h1", { text: @table1.name }
    assert_select "span.badge",
                  { text: "#{@table1.max_persons}",
                    count: 1 }
    assert_select "span.badge",
                  { text: "#{@table1.num_persons}",
                    count: 1 }
    if @table1.occupied?
      assert_select "span.label", { text: "OCCUPIED" }
    else
      assert_select "span.label", { text: "FREE" }
    end
    assert_select "div.panel-heading",
                  { text: "Orders: #{@table1.orders.count}" }
    @table1.orders.each do |order|
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

end
