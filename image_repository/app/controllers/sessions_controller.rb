class SessionsController < ApplicationController
  before_action :correct_user, only: [:create, :new]
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      flash[:success] = "Welcome to the Image Repo Uploader"
      redirect_to user_path(user)
      log_in(user)
    else
      flash[:error] = "Error signing in!!"
      redirect_to login_path
    end
  end

  def destroy
    logout
    redirect_to root_url
  end

end
