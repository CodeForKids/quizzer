require 'test_helper'

class QuestionGroupsControllerTest < ActionController::TestCase
  setup do
    @admin = create(:admin)
    @kid = create(:kid)
    sign_in :user, @admin

    @question_group = create(:question_group)
    @question_group2 = create(:question_group)
  end

  test 'get index' do
    get :index
    assert assigns(:question_groups)
    assert_equal 2, assigns(:question_groups).count
    assert_equal 1, assigns(:question_groups).first[1].size
  end

  test 'post create' do
    assert_difference->{Rapidfire::QuestionGroup.count} do
      post :create, question_group: question_group_params
    end
    assert assigns(:question_group)
  end

  test 'delete destroy' do
    assert_difference->{Rapidfire::QuestionGroup.count}, -1 do
      delete :destroy, id: @question_group
    end
    assert assigns(:question_group)
  end

  test 'post assign Quiz' do
    assert_difference->{QuizAssignment.count} do
      post :assign_to_user, user_id: @kid, id: @question_group
    end
    assert_redirected_to user_path(@kid)
  end

  test 'post assign Quiz group' do
    assert_difference->{QuizAssignment.count} do
      post :assign_group_to_user, user_id: @kid, group_id: @question_group.quiz_group_id
    end
    assert_redirected_to user_path(@kid)
  end

  #Admin

  test 'kids should be able to get index' do
    sign_in :user, @kid
    get :index
    assert assigns(:question_groups)
    assert_equal 2, assigns(:question_groups).count
    assert_equal 1, assigns(:question_groups).first[1].size
  end

  test 'kids should not be able to post create' do
    sign_in :user, @kid
    assert_no_difference->{Rapidfire::Question.count} do
      post :create, question_group: question_group_params
    end
    assert_nil assigns(:question_group)
    assert_redirected_to root_path
  end

  test 'kids should not be able to delete destroy' do
    sign_in :user, @kid
    assert_no_difference->{Rapidfire::QuestionGroup.count}, -1 do
      delete :destroy, id: @question_group
    end
    assert_nil assigns(:question_group)
    assert_redirected_to root_path
  end

  def question_group_params
    question_group_params = @question_group.attributes
    question_group_params.delete('id')
    question_group_params.delete('created_at')
    question_group_params.delete('updated_at')
    question_group_params
  end

end
