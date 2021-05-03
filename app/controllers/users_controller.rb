class UsersController < ApplicationController
  before_action :control, only: [:show]
  before_action :logged_in, only: [:show]
  before_action :correct_user, only: [:new, :create]

  def new
    @user = User.new
  end

  def show
    @image  = current_user.images.build
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash_message('success', 'Welcome to the Image Repo Uploader')
      redirect_to user_path(@user)
      log_in(@user)
    else
      flash_message('error', 'Error signing up!! Make sure password is not blank')
      redirect_to signup_path
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password,
                                 :password_confirmation)
  end

  def control
    if params[:id].present? && current_user.present?
      redirect_to user_path(current_user) and return if params[:id] != current_user.id.to_s
    end
  end
end
