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

  def update
    user = User.find_by(id: params[:id])
    if user
      if user.update_attributes(user_params)
        render json: user,
               status: 200
      else
        render json: { errors: user.errors.full_messages },
               status: 422
      end
    else
      render json: { errors: ["User is invalid"] },
             status: 422
    end
  end

  def destroy
    user = User.find_by(id: params[:id])
    if user
      user.destroy
      head 204
    else
      render json: { errors: ["User is invalid"] },
             status: 422
    end
  end

  private

    def user_params
      params.require(:user).permit(:name,
                                   :email,
                                   :password,
                                   :password_confirmation)
    end

end
