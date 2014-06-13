class QuizAssignment < ActiveRecord::Base
  belongs_to :question_group, :class_name => "Rapidfire::QuestionGroup"
  belongs_to :user
end
