FactoryGirl.define do
  factory :question_group, :class => "Rapidfire::QuestionGroup" do
    name  "Survey"
    quiz_group_id { FactoryGirl.create(:quiz_group).id }
  end
end
