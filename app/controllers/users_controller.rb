class UsersController < ApplicationController
  before_filter :authenticate_administrator, except: [:edit, :update, :me]
  before_filter :authenticate_current_user, only: [:edit, :update]
  before_filter :set_user, except: [:index, :new, :create, :me]

  def index
    @admins = User.admins
    @users = User.kids
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
    remove_email if is_current_user? && !can_administer?
    remove_avatar unless params[:remove_avatar].nil?

    if @user.update_attributes(users_params)
      redirect_to users_path, notice: "Updated the user #{@user.name}"
    else
      flash[:error] = "Issues updating user #{@user.name} #{@user.errors.full_messages.to_sentence}"
      redirect_to users_path
    end
  end

  def destroy
    if @user.destroy
      redirect_to users_path, notice: "Successfully deleted user"
    else
      flash[:error] = "Could not delete user #{@user.name}"
      redirect_to users_path
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def users_params
    params.require(:user).permit(:first_name, :last_name, :password, :email, :avatar)
  end

  def setup_user_profile(user)
    @answer_groups = Rapidfire::AnswerGroup.where(user: user).includes(:question_group)
    @quiz_assignments = QuizAssignment.where(user: user, completed: false).includes(:question_group)
    @completed = QuizAssignment.where(user: user, completed: true)
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

  def authenticate_current_user
    redirect_to root_path unless is_current_user?
  end

  def is_current_user?
    current_user.id.to_i == params[:id].to_i || can_administer?
  end

  def remove_avatar
    @user.remove_avatar!
  end

end
