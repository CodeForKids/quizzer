class UsersController < ApplicationController

  before_action :set_user, except: [:index, :new, :create, :me]
  before_filter :authenticate, except: :me

  def index
    @users = User.all
  end

  def me
    @user = current_user
    @answer_groups = Rapidfire::AnswerGroup.where(user: @user).includes(:question_group)
    render 'show'
  end

  def show
    @answer_groups = Rapidfire::AnswerGroup.where(user: @user).includes(:question_group)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(users_params)
    if @user.valid?
      redirect_to users_path, notice: "Created the user #{@user.name}"
    else
      flash[:error] = "Issues creating user #{@user.name} #{@user.errors.full_messages.to_sentence}"
      redirect_to users_path
    end
  end

  def edit
  end

  def update
    remove_blank_password
    if @user.update_attributes(users_params)
      redirect_to users_path, notice: "Updated the user #{@user.name}"
    else
      flash[:error] = "Issues updating user #{@user.name} #{@user.errors.full_messages.to_sentence}"
      redirect_to users_path
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def users_params
    params.require(:user).permit(:first_name, :last_name, :password, :email)
  end

  def remove_blank_password
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
    end
  end

  def authenticate
    redirect_to root_path unless can_administer?
  end
end
