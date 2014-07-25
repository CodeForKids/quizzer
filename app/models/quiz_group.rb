class QuizGroup < ActiveRecord::Base
  has_many :question_group
  validates :name, presence: true

  def quizzes
    Rapidfire::QuestionGroup.where(quiz_group_id: self.id)
  end
end
