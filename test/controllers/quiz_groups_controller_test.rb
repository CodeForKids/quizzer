require 'test_helper'

class QuizGroupsControllerTest < ActionController::TestCase
  setup do
    @quiz_group = create(:quiz_group)
    @kid = create(:kid)
    sign_in :user, @kid
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:quiz_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create quiz_group" do
    assert_difference('QuizGroup.count') do
      post :create, quiz_group: { name: 'New QuizGroup'  }
    end

    assert_equal 'New QuizGroup', assigns(:quiz_group).name
    assert_redirected_to quiz_groups_path
  end

  test "should get edit" do
    get :edit, id: @quiz_group
    assert_response :success
  end

  test "should update quiz_group" do
    patch :update, id: @quiz_group, quiz_group: { name: 'new name' }
    assert_equal 'new name', assigns(:quiz_group).name
    assert_redirected_to quiz_groups_path
  end

  test "should destroy quiz_group" do
    assert_difference('QuizGroup.count', -1) do
      delete :destroy, id: @quiz_group
    end

    assert_redirected_to quiz_groups_path
  end
end
