class API::APIController < ActionController::Base
  # Prevent CSRF attacks by providing an empty session.
  protect_from_forgery with: :null_session
  skip_before_filter :verify_authenticity_token

  respond_to :json

  def current_user
    @current_user ||= User.find_by(authentication_token: request.headers['Authorization'])
  end

end
