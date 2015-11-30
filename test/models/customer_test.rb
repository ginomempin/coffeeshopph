require 'test_helper'

class CustomerTest < ActiveSupport::TestCase

  def setup
    @customer = Customer.new(server_id: 1, table_id: 1)
  end

  test "should create a valid customer" do
    assert @customer.valid?
  end

  test "empty server should be invalid" do
    @customer.server_id = nil
    assert_not @customer.valid?
  end

  test "empty table should be invalid" do
    @customer.table_id = nil
    assert_not @customer.valid?
  end

  test "servers can serve and clear a table" do
    server1 = users(:user1)
    table1 = tables(:table1)

    assert_not server1.serving?(table1)
    assert_equal 0, server1.customers.count
    assert_nil table1.server

    server1.serve(table1)
    assert server1.serving?(table1)
    assert_equal 1, server1.customers.count
    assert_not_nil table1.reload.server

    server1.clear(table1)
    assert_not server1.serving?(table1)
    assert_equal 0, server1.customers.count
    assert_nil table1.reload.server
  end

  test "servers are uniquely assigned to a table" do
    server1 = users(:user1)
    server2 = users(:user2)
    table1 = tables(:table1)
    table2 = tables(:table2)

    server1.serve(table1)
    server2.serve(table2)

    assert_not_equal table1.reload.server, table2.reload.server
    assert table1.server, server1
    assert table2.server, server2
  end

end
