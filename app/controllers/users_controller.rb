class UsersController < ApplicationController
  before_action :require_logged_in_user,  only: [:edit, :update]
  before_action :require_correct_user,    only: [:edit, :update]

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # automatically log in the new user
      log_in(@user)
      # update the messages for page alerts
      flash[:success] = "Welcome to the #{APP_NAME}!"
      # redirect to the user page
      redirect_to user_url(@user)
    else
      # redisplay the signup form
      render 'new'
    end
  end

  def edit
    # @user is already defined in a before action
  end

  def update
    # @user is already defined in a before action
    if @user.update_attributes(user_params)
      # update the messages for page alerts
      flash[:success] = "Changes were successfully saved."
      # redirect to the user page
      redirect_to user_url(@user)
    else
      # redisplay the edit form
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name,
                                   :email,
                                   :password,
                                   :password_confirmation)
    end

    def require_logged_in_user
      unless logged_in?
        # remember the URL that the user is trying to access
        # so the user can be redirected back to it after a
        # successful login
        store_location
        flash[:danger] = "Please log in to access the page."
        redirect_to login_url
      end
    end

    def require_correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

end
