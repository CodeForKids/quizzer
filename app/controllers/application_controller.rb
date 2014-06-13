class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ApplicationHelper
  before_action :authenticate, :check_help

  def ping
    render inline: 'ACK'
  end

  private

  def authenticate_administrator
    redirect_to root_path unless can_administer?
  end

  def authenticate
    redirect_to new_user_session_path unless current_user
  end

  def check_help
    unless params[:help].nil?
      flash[:notice] = "We'll try to help you out soon! Keep an eye on your email :)"
    end
  end
end
