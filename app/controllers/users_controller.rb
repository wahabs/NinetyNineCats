class UsersController < ApplicationController
  before_action :redirect_if_logged_in, only: :new
  
  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in!(@user)
      redirect_to user_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def show
    @user = current_user
    render :show
  end

  private
  def user_params
    params.require(:user).permit(:user_name, :password)
  end
end
