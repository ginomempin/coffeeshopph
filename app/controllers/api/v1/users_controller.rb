class API::V1::UsersController < API::APIController

  def show
    user = User.find_by(id: params[:id])
    if user
      render json: user,
             status: 200
    else
      render json: { errors: ["User is invalid"] },
             status: 422
    end
  end

end
