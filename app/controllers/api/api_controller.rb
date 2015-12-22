class API::APIController < ActionController::Base
  # Prevent CSRF attacks by providing an empty session.
  protect_from_forgery with: :null_session
  skip_before_filter :verify_authenticity_token

  respond_to :json

  def current_user
    @current_user ||= User.find_by(authentication_token: request.headers['Authorization'])
  end

  def require_logged_in_user
    unless current_user
      render json: { errors: ["User is unauthorized"] },
             status: 401
    end
  end

  def require_correct_user
    user = User.find_by(id: params[:id])
    if user
      unless user == current_user
        render json: { errors: ["User is unauthorized"] },
               status: 401
      end
    else
      render json: { errors: ["User is invalid"] },
             status: 422
    end
  end

end
