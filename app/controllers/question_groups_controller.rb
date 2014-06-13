class QuestionGroupsController < ApplicationController
  before_filter :authenticate_administrator, except: :index
  before_action :set_question_group, only: [:destroy, :results, :assign_to_user]
  respond_to :html, :js
  respond_to :json, only: :results

  def index
    @question_groups = Rapidfire::QuestionGroup.all
    respond_with(@question_groups)
  end

  def create
    @question_group = Rapidfire::QuestionGroup.new(question_group_params)
    @question_group.save

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

  private
  def question_group_params
    params.require(:question_group).permit(:name)
  end

  def set_question_group
    @question_group = Rapidfire::QuestionGroup.find(params[:id])
  end
end
