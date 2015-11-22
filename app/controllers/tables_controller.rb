class TablesController < ApplicationController
  before_action :require_logged_in_user, only: [:index, :show]

  def index
    # TODO: make these settings configurable on the page
    @tables = Table.order(name: :asc)
  end

  def show
    @table = Table.find_by(id: params[:id])

    # for the Add Order form:
    # instance of an unsaved Order object associated with this Table
    @order = @table.orders.build

    # for the list of Orders:
    # instance for all the saved Orders associated with this Table
    @orders = @table.order_list
  end

end
