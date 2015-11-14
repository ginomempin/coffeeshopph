require 'test_helper'

class OrderTest < ActiveSupport::TestCase

  def setup
    @table = tables(:table1)
    @order = @table.orders.build(name:     "Order 1",
                                 price:    300,
                                 quantity: 1,
                                 served:   false)
  end

  test "should create a valid order" do
    assert @order.valid?
  end

  test "no table association should be invalid" do
    @order.table_id = nil
    assert_not @order.valid?
  end

  test "empty name should be invalid" do
    @order.name = nil
    assert_not @order.valid?
    @order.name = ""
    assert_not @order.valid?
    @order.name = "   "
    assert_not @order.valid?
  end

  test "too long names should be invalid" do
    @order.name = ("a" * 51)
    assert_not @order.valid?
  end

  test "price should be between zero and 99,999.99" do
    @order.price = -1
    assert_not @order.valid?
    @order.price = 0
    assert @order.valid?
    @order.price = 1
    assert @order.valid?
    @order.price = 99999.99
    assert @order.valid?
    @order.price = 1000000.00
    assert_not @order.valid?
  end

  test "quantity should be at least 1" do
    @order.quantity = -1
    assert_not @order.valid?
    @order.quantity = 0
    assert_not @order.valid?
    @order.quantity = 1
    assert @order.valid?
    @order.quantity = 2
    assert @order.valid?
  end

  test "order should be most recent first" do
    assert_equal orders(:order1), Order.first
  end

end
