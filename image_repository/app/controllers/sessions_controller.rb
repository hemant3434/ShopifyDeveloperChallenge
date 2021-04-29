class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      flash[:success] = "Welcome to the Image Repo Uploader"
      redirect_to user_path(user)
      login(user)
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
