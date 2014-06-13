class QuestionsController < ApplicationController
  before_filter :authenticate_administrator
  respond_to :html, :js

  before_filter :find_question_group!
  before_filter :find_question!, :only => [:edit, :update, :destroy]

  def index
    @questions = @question_group.questions
    respond_with(@questions)
  end

  def new
    @question = Rapidfire::QuestionForm.new(:question_group => @question_group)
    respond_with(@question)
  end

  def create
   update_or_create_question
  end

  def edit
    @question = Rapidfire::QuestionForm.new(:question => @question)
    respond_with(@question)
  end

  def update
    @question.update_attributes(question_form_to_question_params)
    respond_with(@question, location: index_location)
  end

  def destroy
    @question.destroy
    respond_with(@question, location: index_location)
  end

  private

  def update_or_create_question
    form_params = params[:question].merge(:question_group => @question_group)
    @question = Rapidfire::QuestionForm.new(form_params)
    @question.save

    respond_with(@question, location: index_location)
  end

  def question_form_to_question_params
    {
        :type => question_params[:type],
        :question_text  => question_params[:question_text],
        :answer_options => question_params[:answer_options],
        :hint => question_params[:hint],
        :answer => question_params[:answer],
        :validation_rules => {
          :presence => question_params[:answer_presence],
          :minimum  => question_params[:answer_minimum_length],
          :maximum  => question_params[:answer_maximum_length],
          :greater_than_or_equal_to => question_params[:answer_greater_than_or_equal_to],
          :less_than_or_equal_to    => question_params[:answer_less_than_or_equal_to]
        }
      }
  end

  def question_params
    params.require(:question).permit(:type, :question_text, :answer, :hint, :answer_options,
                                     :answer_presence, :answer_minimum_length, :answer_maximum_length,
                                     :answer_greater_than_or_equal_to, :answer_less_than_or_equal_to)
  end

  def find_question_group!
    @question_group = Rapidfire::QuestionGroup.find(params[:question_group_id])
  end

  def find_question!
    @question = @question_group.questions.find(params[:id])
  end

  def index_location
    question_group_questions_url(@question_group)
  end
end
