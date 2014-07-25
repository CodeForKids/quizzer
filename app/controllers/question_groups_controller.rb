class QuestionGroupsController < ApplicationController
  before_filter :authenticate_administrator, except: :index
  before_action :set_question_group, only: [:destroy, :update, :assign_to_user]
  respond_to :html, :js
  respond_to :json, only: :results

  def index
    @question_groups = Rapidfire::QuestionGroup.all.group_by(&:quiz_group_id)
    respond_with(@question_groups)
  end

  def create
    @question_group = Rapidfire::QuestionGroup.new(question_group_params)
    @question_group.save

    respond_with(@question_group, location: question_groups_url)
  end

  def update
    @question_group.update_attributes(question_group_params)
    respond_with(@question_group, location: question_groups_url)
  end

  def destroy
    @question_group.destroy
    respond_with(@question_group)
  end

  def assign_to_user
    @user = User.find(params[:user_id])
    if QuizAssignment.create({user: @user, question_group: @question_group, source: 'Tutor'})
      redirect_to user_path(@user), notice: "Successfully assigned quiz to #{@user.name}"
    else
      flash[:error] = "Could not assign Quiz to #{@user.name}"
      redirect_to user_path(@user)
    end
  end

  def assign_group_to_user
    @user = User.find(params[:user_id])
    @group = QuizGroup.find(params[:group_id])
    @group.quizzes.each do |quiz|
      QuizAssignment.create({user: @user, question_group: quiz, source: 'Tutor'})
    end
    redirect_to user_path(@user)
  end

  private
  def question_group_params
    params.require(:question_group).permit(:name, :quiz_group_id)
  end

  def set_question_group
    @question_group = Rapidfire::QuestionGroup.find(params[:id])
  end
end
