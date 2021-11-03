class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  before_action :check_login, only: %i[new create]
  
  def index
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(session[:user_id])
  end

  def update
    @user = User.find(session[:user_id])
    @user.avatar.attach(params[:avatar])
    if @user.valid? && @user.update(user_edit_params)
      session[:user_id] = @user.id
    else
      flash[:error] = 'Error- please try to update an account again.'
    end

    redirect_to @user
  end

  def create
    @user = User.create(user_params)
    if @user.valid?
      session[:user_id] = @user.id
      redirect_to @user
    else
      flash[:error] = 'Error- please try to create an account again.'
      redirect_to new_user_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :middle_name, :last_name, :gender, :relationship, :emails, :password, :avatar)
  end

  def user_edit_params
    params.require(:user).permit(:first_name, :middle_name, :last_name, :gender, :relationship, :emails, :avatar)
  end
end
