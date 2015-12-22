class API::V1::SessionsController < API::APIController

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        # The user's authentication_token is renewed on each
        # login so that even if it was compromised on an old
        # transaction, logging-in for a new transaction will
        # render the old token useless.
        # TODO: the authentication_token should be merged with the remember_token
        user.update_authentication_token!
        render json: { id: user.id, authentication_token: user.authentication_token },
               status: 200
      else
        render json: { errors: ["This account is not yet activated"] },
               status: 401
      end
    else
      render json: { errors: ["Invalid email or password"] },
             status: 422
    end
  end

  def destroy
    # The user's authentication_token is expired on each
    # logout so that even if it was compromised on an old
    # transaction, logging-out the current transaction will
    # render the old token useless.
    # TODO: the authentication_token should be merged with the remember_token
    user = User.find_by(authentication_token: params[:id])
    user.update_authentication_token!
    head 204
  end

end
