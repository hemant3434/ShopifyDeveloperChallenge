class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  protected
  def correct_user
    redirect_to user_path(current_user) and return if current_user.present?
  end
end
