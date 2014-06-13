require 'test_helper'

class QuestionsControllerTest < ActionController::TestCase
  setup do
    @admin = create(:admin)
    @kid = create(:kid)
    sign_in :user, @admin

    @question_group = create(:question_group)
    @question_checkbox = FactoryGirl.create(:q_checkbox, :question_group => @question_group)
    @question_date = FactoryGirl.create(:q_date, :question_group => @question_group)
  end

  test 'get index' do
    get :index, question_group_id: @question_group
    assert assigns(:questions)
    assert_equal 2, assigns(:questions).count
  end

  test 'get new' do
    get :new, question_group_id: @question_group
    assert assigns(:question)
  end

  test 'get edit' do
    get :edit, question_group_id: @question_group, id: @question_checkbox
    assert_equal @question_checkbox, assigns(:question).question
  end

  test 'post create' do
    assert_difference->{Rapidfire::Question.count} do
      post :create, question_group_id: @question_group, question: question_params
    end
    assert assigns(:question).question
  end

  test 'put update' do
    put :update, question_group_id: @question_group, id: @question_date, question: question_params
    assert assigns(:question)
    assert_equal @question_checkbox.type, assigns(:question).type
  end

  test 'delete destroy' do
    assert_difference->{Rapidfire::Question.count}, -1 do
      delete :destroy, question_group_id: @question_group, id: @question_checkbox
    end
    assert assigns(:question)
  end

  #Admin

  test 'kids should not be able to get index' do
    sign_in :user, @kid
    get :index, question_group_id: @question_group
    assert_nil assigns(:questions)
    assert_redirected_to root_path
  end

  test 'kids should not be able to get new' do
    sign_in :user, @kid
    get :new, question_group_id: @question_group
    assert_nil assigns(:question)
    assert_redirected_to root_path
  end

  test 'kids should not be able to get edit' do
    sign_in :user, @kid
    get :edit, question_group_id: @question_group, id: @question_checkbox
    assert_redirected_to root_path
  end

  test 'kids should not be able to post create' do
    sign_in :user, @kid
    assert_no_difference->{Rapidfire::Question.count} do
      post :create, question_group_id: @question_group, question: question_params
    end
    assert_nil assigns(:question)
    assert_redirected_to root_path
  end

   test 'kids should not be able to put update' do
    sign_in :user, @kid
    put :update, question_group_id: @question_group, id: @question_date, question: question_params
    assert_nil assigns(:question)
    assert_redirected_to root_path
  end

  test 'kids should not be able to delete destroy' do
    sign_in :user, @kid
    assert_no_difference->{Rapidfire::Question.count}, -1 do
      delete :destroy, question_group_id: @question_group, id: @question_checkbox
    end
    assert_nil assigns(:question)
    assert_redirected_to root_path
  end

  def question_params
    question_params = @question_checkbox.attributes
    question_params.delete('id')
    question_params.delete('question_group_id')
    question_params.delete('position')
    question_params.delete('validation_rules')
    question_params.delete('created_at')
    question_params.delete('updated_at')
    question_params
  end

end
