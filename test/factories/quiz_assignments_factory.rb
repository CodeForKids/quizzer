FactoryGirl.define do
  factory :quiz_assignment, :class => "QuizAssignment" do
    source 'Tutor'
  end
end
