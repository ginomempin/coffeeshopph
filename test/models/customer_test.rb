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
    # choose a server and a table that is not in fixtures
    server1 = users(:user1)
    table6 = tables(:table6)

    assert_not server1.serving?(table6)
    assert_equal 0, server1.customers.count
    assert_nil table6.server

    server1.serve(table6)
    assert server1.serving?(table6)
    assert_equal 1, server1.customers.count
    assert_not_nil table6.reload.server

    server1.clear(table6)
    assert_not server1.serving?(table6)
    assert_equal 0, server1.customers.count
    assert_nil table6.reload.server
  end

  test "servers are uniquely assigned to a table" do
    server3 = users(:user3)
    server5 = users(:user5)
    table3 = tables(:table3)
    table5 = tables(:table5)

    assert_not_equal table3.server, table5.server
    assert table3.server, server3
    assert table5.server, server5
  end

end
