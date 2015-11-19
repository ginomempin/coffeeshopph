class UsersController < ApplicationController
  before_action :require_logged_in_user,  only: [:index, :show, :edit, :update, :destroy]
  before_action :require_correct_user,    only: [:edit, :update]
  before_action :require_admin_user,      only: [:destroy]

  def index
    # TODO: make these settings configurable on the page
    @users = User.where(activated: true)
                 .order(name: :asc)
                 .paginate(page: params[:page],
                           per_page: USERS_DEFAULT_PER_PAGE)
  end

  def show
    @user = User.find(params[:id])
    unless @user.activated?
      redirect_to root_url and return
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
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
                                   :password_confirmation,
                                   :picture)
    end

    def require_correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def require_admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
