class UsersController < ApplicationController

  before_action :set_user, except: [:index, :new, :create, :me]
  before_filter :authenticate, except: [:edit, :update, :me]
  before_filter :authenticate_current_user, only: [:edit, :update]

  def index
    @users = User.all
  end

  def me
    @user = current_user
    setup_user_profile(@user)
    render 'show'
  end

  def show
    setup_user_profile(@user)
  end

  def assign_quiz
    setup_user_profile(@user)
    @question_groups =  Rapidfire::QuestionGroup.where.not(id: @completed.select(:question_group_id))
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
    remove_email if current_user? && !can_administer?
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

  def setup_user_profile(user)
    @answer_groups = Rapidfire::AnswerGroup.where(user: user).includes(:question_group)
    @quiz_assignments = QuizAssignment.where(user: user, completed: false).includes(:question_group)
    @completed = QuizAssignment.where(user: user)
  end

  def remove_blank_password
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
    end
  end

  def remove_email
    params[:user].delete(:email)
  end

  def authenticate
    redirect_to root_path unless can_administer?
  end

  def authenticate_current_user
    redirect_to root_path unless current_user?
  end

  def current_user?
    current_user.id.to_i == params[:id].to_i || can_administer?
  end
end
