class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include ApplicationHelper
  protected
  def correct_user
    redirect_to user_path(current_user) and return if logged_in?
  end

  def logged_in
    redirect_to root_url and return if !logged_in?
  end
end
