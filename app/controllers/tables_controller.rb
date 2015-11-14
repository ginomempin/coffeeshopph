class TablesController < ApplicationController
  before_action :require_logged_in_user, only: [:index, :show]

  def index
    # TODO: make these settings configurable on the page
    table_order = TABLES_DEFAULT_ORDER_BY
    @tables = Table.order(table_order)
  end

  def show
    @table = Table.find_by(id: params[:id])
  end

end
