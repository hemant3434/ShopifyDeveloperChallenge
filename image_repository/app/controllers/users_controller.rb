class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @image  = current_user.images.build
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Image Repo Uploader "
      redirect_to user_path(@user)
      login(@user)
    else
      flash[:error] = "Error signing in!!"
      redirect_to signup_path
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password,
                                 :password_confirmation)
  end
end
