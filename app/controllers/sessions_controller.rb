class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        # log the user in and remember the session
        log_in(@user)
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        # redirect to the forward URL or the user page
        redirect_to_stored_location_or(user_url(@user))
      else
        message = "This account is not yet activated."
        message += " Check your email for the verification link"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      # redisplay the login form
      flash.now[:danger] = "The submitted email / password combination is invalid."
      render 'new'
    end
  end

  def destroy
    # log the user out
    log_out if logged_in?
    # redirect to the home page
    redirect_to root_url
  end

end
