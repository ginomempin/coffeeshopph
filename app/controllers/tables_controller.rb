class TablesController < ApplicationController
  before_action :require_logged_in_user, only: [:index, :show]

  def index
    # TODO: make these settings configurable on the page
    @tables = Table.order(name: :asc)
  end

  def show
    @table = Table.find_by(id: params[:id])
  end

end
