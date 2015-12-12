class API::V1::TablesController < API::APIController

  def show
    table = Table.find_by(id: params[:id])
    if table
      render json: table,
             status: 200
    else
      render json: { errors: ["Table is invalid"] },
             status: 422
    end
  end

end
