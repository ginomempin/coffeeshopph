class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # log the user in
      log_in(user)
      # redirect to the user page
      redirect_to user_url(user)
    else
      # redisplay the login form
      flash.now[:danger] = "The submitted Email / Password combination is invalid."
      render 'new'
    end
  end

  def destroy
  end

end
