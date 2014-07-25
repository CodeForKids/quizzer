class QuizGroupsController < ApplicationController
  before_action :set_quiz_group, only: [:show, :edit, :update, :destroy]

  def index
    @quiz_groups = QuizGroup.all
  end

  def new
    @quiz_group = QuizGroup.new
  end

  def edit
  end

  def create
    @quiz_group = QuizGroup.new(quiz_group_params)

    if @quiz_group.save
      redirect_to quiz_groups_path, notice: 'Quiz group was successfully created.'
    else
      render :new
    end
  end

  def update
    if @quiz_group.update(quiz_group_params)
      redirect_to quiz_groups_path, notice: 'Quiz group was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @quiz_group.destroy
    redirect_to quiz_groups_path, notice: 'Quiz group was successfully destroyed.'
  end

  private

  def set_quiz_group
    @quiz_group = QuizGroup.find(params[:id])
  end

  def quiz_group_params
    params.require(:quiz_group).permit(:name)
  end
end
