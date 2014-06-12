class AnswerGroupsController < ApplicationController
  before_filter :find_question_group!

  def new
    @answer_group_builder = Rapidfire::AnswerGroupBuilder.new(answer_group_params)
  end

  def show
    @answer_group = Rapidfire::AnswerGroup.find(params[:id])
  end

  def create
    @answer_group_builder = Rapidfire::AnswerGroupBuilder.new(answer_group_params)

    if @answer_group_builder.save
      mark_question_group_as_complete
      redirect_to question_group_answer_group_path(@answer_group_builder.question_group, @answer_group_builder.to_model)
    else
      render :new
    end
  end

  private
  def find_question_group!
    @question_group = Rapidfire::QuestionGroup.find(params[:question_group_id])
  end

  def answer_group_params
    answer_params = { params: params[:answer_group] }
    answer_params.merge(user: current_user, question_group: @question_group)
  end

  def mark_question_group_as_complete
    quiz_assignment = QuizAssignment.find_or_create_by_answer_group_builder(@answer_group_builder)
    quiz_assignment.completed = true
    quiz_assignment.attempts += 1
    quiz_assignment.save
  end
end
