class API::V1::OrdersController < API::APIController
  before_action :require_logged_in_user, only: [:index, :create, :destroy]

  def index
    table = Table.find_by(id: params[:table_id])
    if table
      render json: table.orders.filter(params.slice(:served)),
             status: 200
    else
      render json: { errors: ["Table is invalid"] },
             status: 422
    end
  end

  def create
    #TODO: add verification if current_user is a Customer of the Table
    table = Table.find_by(id: params[:table_id])
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

  def destroy
    table = Table.find_by(id: params[:table_id])
    if table
      order = table.orders.find_by(id: params[:id])
      if order
        order.destroy
        head 204
      else
        render json: { errors: ["Order is invalid"] },
               status: 422
      end
    else
      render json: { errors: ["Table is invalid"] },
             status: 422
    end
  end

  private

    def order_params
      params.require(:order).permit(:name, :price, :quantity)
    end

end
