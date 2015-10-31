class PasswordResetsController < ApplicationController
  before_action :get_user,          only: [:edit, :update]
  before_action :validate_user,     only: [:edit, :update]
  before_action :check_expiration,  only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_password_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Please check your email for password reset instructions."
      redirect_to root_url
    else
      flash.now[:danger] = "The submitted email address was not found."
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty.")
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in(@user)
      flash[:success] = "Password was successfully reset"
      redirect_to user_url(@user)
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email].downcase)
    end

    def validate_user
      unless (@user &&
              @user.activated? &&
              @user.authenticated?(:password_reset, params[:id]))
        redirect_to root_url
      end
    end

    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "The password reset link has expired."
        redirect_to new_password_reset_url
      end
    end

end
