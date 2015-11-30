require 'test_helper'

class TableTest < ActiveSupport::TestCase

  def setup
    @table = Table.new(name:        "Table 1",
                       max_persons: 4,
                       num_persons: 2,
                       occupied:    true,
                       total_bill:  500)
  end

  test "should create a valid table" do
    assert @table.valid?
  end

  test "empty name should be invalid" do
    @table.name = nil
    assert_not @table.valid?
    @table.name = ""
    assert_not @table.valid?
    @table.name = "   "
    assert_not @table.valid?
  end

  test "too long names should be invalid" do
    @table.name = ("a" * 51)
    assert_not @table.valid?
  end

  test "max_persons should be between 2 and 4" do
    @table.max_persons = 1
    assert_not @table.valid?
    @table.max_persons = 2
    assert @table.valid?
    @table.max_persons = 4
    assert @table.valid?
    @table.max_persons = 5
    assert_not @table.valid?
  end

  test "num_persons should be between 0 and max_persons" do
    @table.max_persons = 4
    @table.num_persons = 5
    assert_not @table.valid?
    @table.num_persons = 4
    assert @table.valid?
    @table.num_persons = 3
    assert @table.valid?
    @table.num_persons = -1
    assert_not @table.valid?
  end

  test "occupied should become false when num_persons is 0" do
    @table.num_persons = 0
    @table.save
    assert_not @table.occupied?
  end

  test "occupied should become true when num_persons is not 0" do
    @table.num_persons = 1
    @table.save
    assert @table.occupied?
  end

  test "total_bill should be non-negative" do
    @table.total_bill = -1
    assert_not @table.valid?
    @table.total_bill = 0
    assert @table.valid?
    @table.total_bill = 1
    assert @table.valid?
  end

  test "delete associated orders when table is deleted" do
    @table.save
    @table.orders.create(name:     "Order 1",
                         price:    300,
                         quantity: 1,
                         served:   false)
    assert_difference 'Order.count', -1 do
      @table.destroy
    end
  end

  # result is based on fixtures for Table 1
  test "should retrieve list of associated orders" do
    @orders = tables(:table1).order_list

    # check that the correct associated orders are retrieved
    assert_not_nil @orders
    assert_equal 3, @orders.count

    # check the ordering
    assert_equal orders(:order1), @orders.find_by(name: "Order 1")
    assert_equal orders(:order2), @orders.find_by(name: "Order 2")
    assert_equal orders(:order3), @orders.find_by(name: "Order 3")
  end

  test "should clear destroy orders" do
    table2 = tables(:table2)
    assert_not table2.orders.empty?

    order_count = table2.orders.count
    assert_difference 'Order.count', -2 do
      table2.clear_orders
    end

    assert table2.reload.orders.empty?
  end

end
