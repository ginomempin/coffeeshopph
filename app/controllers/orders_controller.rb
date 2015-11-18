class OrdersController < ApplicationController
  before_action :require_logged_in_user, only: [:index, :show, :create, :destroy]

  def index
    # TODO: make these settings configurable on the page
    @orders = Order.order(name: :asc)
  end

  def show
    @order = Order.find_by(id: params[:id])
  end

  def create
    @table = Table.find_by(id: params[:order][:table_id])
    if @table
      @order = @table.orders.build(order_params)
      if @order.save
        flash[:success] = "Order added!"
        redirect_to table_path(@table.id)
      else
        # re-render the Table info page
        # need to re-initialize missing instance vars from the Table controller
        @orders = @table.order_list
        render 'tables/show'
      end
    else
      flash[:danger] = "Table is invalid!"
      redirect_to tables_path
    end
  end

  def destroy
  end

  private

    def order_params
      params.require(:order).permit(:name, :price, :quantity, :table_id)
    end

end
