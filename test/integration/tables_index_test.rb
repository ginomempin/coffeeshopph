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

  test "should display table info" do
    #1. login
    check_log_in_as(@admin1)
    #2. access the tables info page
    get table_path(@table1.id)
    assert_template "tables/show"
    #3. check the contents of the page
    assert_select "h1", { text: @table1.name }
    assert_select "span.badge", { text: "#{@table1.max_persons}",
                                  count: 1 }
    assert_select "span.badge", { text: "#{@table1.num_persons}",
                                  count: 1 }
    if @table1.occupied?
      assert_select "span.label", { text: "OCCUPIED" }
    else
      assert_select "span.label", { text: "FREE" }
    end
  end

end
