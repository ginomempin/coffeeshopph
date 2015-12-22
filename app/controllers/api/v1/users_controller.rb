class API::V1::UsersController < API::APIController
  before_action :require_logged_in_user,  only: [:show, :update, :destroy]
  before_action :require_correct_user,    only: [:update, :destroy]

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
    user = current_user
    if user.update_attributes(user_params)
      render json: user,
             status: 200
    else
      render json: { errors: user.errors.full_messages },
             status: 422
    end
  end

  def destroy
    user = current_user
    if user.destroy
      head 204
    else
      render json: { errors: user.errors.full_messages },
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
