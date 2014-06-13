require 'test_helper'

class AnswerGroupsControllerTest < ActionController::TestCase
  setup do
    @kid = create(:kid)
    sign_in :user, @kid

    @question_group = create(:question_group)
    @question_checkbox = FactoryGirl.create(:q_checkbox, :question_group => @question_group)
    @answer_group = create(:answer_group, question_group: @question_group)

    @question_group_2 = create(:question_group)
    @question_checkbox_2 = FactoryGirl.create(:q_checkbox, :question_group => @question_group_2)
    @answer_group_2 = create(:answer_group, question_group: @question_group_2)
    @quiz_assignment = create(:quiz_assignment, user: @kid, question_group: @question_group_2, attempts: 1)
  end

  test 'get new' do
    get :new, question_group_id: @question_group
    assert assigns(:answer_group_builder)
  end

  test 'get show' do
    get :show, question_group_id: @question_group, id: @answer_group
    assert assigns(:answer_group)
  end

  test 'post create' do
    assert_difference [->{Rapidfire::AnswerGroup.count},->{QuizAssignment.count}] do
      post :create, question_group_id: @question_group, answer_group: remove_attributes(@answer_group.attributes)
    end
    assert assigns(:answer_group_builder)

    quiz_assignment = assigns(:quiz_assignment)
    assert quiz_assignment
    assert_equal 'manual', quiz_assignment.source
    assert_equal true, quiz_assignment.completed
    assert_equal 1, quiz_assignment.attempts
  end

  test 'post create doesnt create new assignment' do
    assert_difference ->{Rapidfire::AnswerGroup.count} do
      assert_no_difference->{QuizAssignment.count} do
        post :create, question_group_id: @question_group_2, answer_group: remove_attributes(@answer_group_2.attributes)
      end
    end
    assert assigns(:answer_group_builder)

    quiz_assignment = assigns(:quiz_assignment)
    assert quiz_assignment
    assert_equal 'Tutor', quiz_assignment.source
    assert_equal true, quiz_assignment.completed
    assert_equal 2, quiz_assignment.attempts
  end

  def remove_attributes(params)
    params.delete('id')
    params.delete('question_group_id')
    params.delete('position')
    params.delete('validation_rules')
    params.delete('created_at')
    params.delete('updated_at')
    params
  end

end
