class QuizAssignment < ActiveRecord::Base
  belongs_to :question_group, :class_name => "Rapidfire::QuestionGroup"
  belongs_to :user

  def self.find_or_create_by_answer_group_builder(answer_group_builder)
    QuizAssignment.find_or_create_by(question_group: answer_group_builder.question_group, user: answer_group_builder.user)
  end
end
