class UsersController < ApplicationController
  before_action :require_logged_in_user,  only: [:index, :edit, :update, :destroy]
  before_action :require_correct_user,    only: [:edit, :update]
  before_action :require_admin_user,      only: [:destroy]

  def index
    # TODO: make these settings configurable on the page
    user_order = USERS_DEFAULT_ORDER_BY
    user_count = USERS_DEFAULT_PER_PAGE
    @users = User.order(user_order).paginate(page: params[:page],
                                             per_page: user_count)
  end

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
      # redirect to the new user's profile page
      flash[:success] = "Welcome to the #{APP_NAME}!"
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
      # redirect to the user's updated profile page
      flash[:success] = "Changes were successfully saved."
      redirect_to user_url(@user)
    else
      # redisplay the edit profile form
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    # redirect to the list of users page
    flash[:success] = "User was successfully deleted."
    redirect_to users_url
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

    def require_admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
