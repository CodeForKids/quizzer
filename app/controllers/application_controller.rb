class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ApplicationHelper
  before_action :authenticate_session

  private

  def authenticate_session
    redirect_to main_app.new_user_session_path unless current_user
  end
end
