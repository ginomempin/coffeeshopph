class API::V1::OrdersController < API::APIController
  before_action :require_logged_in_user, only: [:create]

  def create
    table = Table.find_by(id: order_params[:table_id])
    if table
      order = table.orders.build(order_params)
      if order.save
        render json: order,
               status: 201
      else
        render json: { errors: order.errors.full_messages },
               status: 422
      end
    else
      render json: { errors: ["Table is invalid"] },
             status: 422
    end
  end

  private

    def order_params
      params.require(:order).permit(:name, :price, :quantity, :table_id)
    end

end
