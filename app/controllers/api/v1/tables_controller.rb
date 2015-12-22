class API::V1::TablesController < API::APIController
  before_action :require_logged_in_user, only: [:show]

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
