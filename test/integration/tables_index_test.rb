require 'test_helper'

class TablesIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin1 = users(:admin1)
    @table1 = tables(:table1)
  end

  test "should display list of tables" do
    #1. login
    check_log_in_as(@admin1)
    #2. access the tables page from the header
    get tables_path
    assert_template "tables/index"
    #3. check the displayed list of tables
    1.upto(5) do |n|
      assert_select "a.list-group-item", { text:  /Table #{n}$/,
                                           count: 1 }
      assert_select "span.badge", { text: "OCCUPIED" }
    end
    6.upto(10) do |n|
      assert_select "a.list-group-item", { text:  /Table #{n}$/,
                                           count: 1 }
      assert_select "span.badge", { text: "FREE" }
    end
  end

end
