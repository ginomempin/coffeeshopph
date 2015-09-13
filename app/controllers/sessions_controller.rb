class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      # log the user in and remember the session
      log_in(@user)
      if params[:session][:remember_me] == '1'
        remember(@user)
      else
        forget(@user)
      end
      # redirect to the user page
      redirect_to user_url(@user)
    else
      # redisplay the login form
      flash.now[:danger] = "The submitted Email / Password combination is invalid."
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
