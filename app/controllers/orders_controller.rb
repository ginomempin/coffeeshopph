class OrdersController < ApplicationController
  before_action :require_logged_in_user, only: [:index, :show]

  def index
    # TODO: make these settings configurable on the page
    @orders = Order.order(name: :asc)
  end

  def show
    @order = Order.find_by(id: params[:id])
  end
end
