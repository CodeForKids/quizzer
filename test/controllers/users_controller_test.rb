require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @admin = create(:admin)
    @kid = create(:kid)
    @kid2 = create(:kid2)
    sign_in :user, @admin

    @question_group = create(:question_group)
    @completed_question_group = create(:question_group)

    @answer_group_kid = create(:answer_group, question_group: @completed_question_group, user: @kid)
    @quiz_assignment_kid = create(:quiz_assignment, user: @kid, question_group: @question_group)
    @quiz_assignment_completed_kid = create(:quiz_assignment, user: @kid, question_group: @completed_question_group, completed: true)

    @answer_group = create(:answer_group, question_group: @completed_question_group, user: @admin)
    @quiz_assignment = create(:quiz_assignment, user: @admin, question_group: @question_group)
    @quiz_assignment_completed = create(:quiz_assignment, user: @admin, question_group: @completed_question_group, completed: true)
  end

  test 'get index' do
    get :index
    assert assigns(:users)
    assert_equal 2, assigns(:users).count
    assert assigns(:admins)
    assert_equal 1, assigns(:admins).count
  end

  test 'get show' do
    get :show, id: @admin
    assert_user_setup
  end

  test 'get me' do
    get :me
    assert_user_setup
  end

  test 'get assign_quiz' do
    get :assign_quiz, id: @admin
    assert_user_setup

    assert assigns(:question_groups)
    assert_equal @question_group, assigns(:question_groups).first
    assert_equal 1, assigns(:question_groups).count
  end

  test 'get new' do
    get :new
    assert assigns(:user)
    assert assigns(:user).new_record?
  end

  test 'get edit' do
    get :edit, id: @admin
    assert assigns(:user)
    assert_equal @admin, assigns(:user)
  end

  test 'should update user' do
    put :update, id: @admin, user: { first_name: 'Julian John' }
    assert_redirected_to users_path

    assert assigns(:user)
    user = assigns(:user)
    assert_equal 'Julian John', user.first_name
    assert_equal "Updated the user Julian John nadeau", flash[:notice]
  end

  test 'should remove avatar' do
    put :update, id: @admin, remove_avatar: "Remove Avatar?", user: { first_name: 'Julian John' }
    assert_redirected_to users_path

    assert assigns(:user)
    user = assigns(:user)
    assert_equal 'Julian John', user.first_name
    assert_nil user.avatar.url
    assert_equal "Updated the user Julian John nadeau", flash[:notice]
  end

  test 'should fail to update user' do
    put :update, id: @admin, user: { email: '' }
    assert_redirected_to users_path
    assert_equal "Issues updating user julian nadeau Email can't be blank", flash[:error]
  end

  test 'should create a new user' do
    assert_difference ->{User.count} do
      post :create, id: @admin, user: { first_name: 'Testy', last_name: 'McGee', email: 'testy@email.com', password: '12345678' }
    end

    assert_redirected_to users_path
    assert_equal "Created the user Testy McGee", flash[:notice]
  end

  test 'should not create a new user' do
    assert_no_difference ->{User.count} do
      post :create, id: @admin, user: { first_name: nil, last_name: '', email: '', password: '12345678' }
    end

    assert_redirected_to users_path
    assert_equal "Issues creating user  Email can't be blank, First name can't be blank, and Last name can't be blank", flash[:error]
  end

  test 'should delete user' do
    assert_difference->{User.count}, -1 do
      delete :destroy, id: @kid
    end
    assert_redirected_to users_path
    assert_equal "Successfully deleted user", flash[:notice]
  end

  test 'should fail to delete user' do
    User.any_instance.stubs(:destroy).returns(false)
    assert_no_difference->{User.count} do
      delete :destroy, id: @kid
    end
    assert_redirected_to users_path
    assert_equal "Could not delete user bob smith", flash[:error]
  end

  # Admin Restrictions

  test 'kids should not be able to get index' do
    sign_in :user, @kid
    get :index
    assert_redirected_to root_path
    assert !assigns(:users)
  end

  test 'kid should be able to get their own profile' do
    sign_in :user, @kid
    get :me

    assert assigns(:user), 'Did not assign user'
    assert_equal @kid, assigns(:user)

    assert assigns(:answer_groups)
    assert_equal @answer_group_kid, assigns(:answer_groups).first
    assert_equal 1, assigns(:answer_groups).count

    assert assigns(:quiz_assignments)
    assert_equal @quiz_assignment_kid, assigns(:quiz_assignments).first
    assert_equal 1, assigns(:quiz_assignments).count

    assert assigns(:completed)
    assert_equal @quiz_assignment_completed_kid, assigns(:completed).first
    assert_equal 1, assigns(:completed).count
  end

  test 'kid should be able to get show' do
    sign_in :user, @kid
    get :show, id: @kid2
    assert_nil assigns(:user)
    assert_redirected_to root_path
  end

  test 'kids should not be able to assign quiz' do
    sign_in :user, @kid
    get :assign_quiz, id: @kid2
    assert !assigns(:question_groups)
    assert_redirected_to root_path
  end

  test 'kids should not be able to get new' do
    sign_in :user, @kid
    get :new
    assert_redirected_to root_path
    assert !assigns(:user)
  end

  test 'kids should not be able to create user' do
    sign_in :user, @kid
    assert_no_difference ->{User.count} do
      post :create, id: @admin, user: { first_name: 'Testy', last_name: 'McGee', email: 'testy@email.com', password: '12345678' }
    end

    assert_redirected_to root_path
  end

  test 'kids should not be able to get edit of another user' do
    sign_in :user, @kid
    get :edit, id: @kid2
    assert_redirected_to root_path
    assert_nil assigns(:user)
  end

  test 'kids should be able to get edit themself' do
    sign_in :user, @kid
    get :edit, id: @kid
    assert assigns(:user)
    assert_equal @kid, assigns(:user)
  end

  test 'kids should not be able to get delete a user' do
    sign_in :user, @kid
    assert_no_difference->{User.count} do
      delete :destroy, id: @kid
    end
    assert_redirected_to root_path
  end

  test 'kid should update self' do
    sign_in :user, @kid
    put :update, id: @kid, user: { first_name: 'Bobby' }
    assert_redirected_to users_path

    assert assigns(:user)
    user = assigns(:user)
    assert_equal 'Bobby', user.first_name
    assert_equal "Updated the user Bobby smith", flash[:notice]
  end

  test 'kid should not be able to update another user' do
    sign_in :user, @kid
    put :update, id: @kid2, user: { first_name: 'Bobby' }
    assert_redirected_to root_path
  end

  def assert_user_setup
    assert assigns(:user), 'Did not assign user'
    assert_equal @admin, assigns(:user)

    assert assigns(:answer_groups)
    assert_equal @answer_group, assigns(:answer_groups).first
    assert_equal 1, assigns(:answer_groups).count

    assert assigns(:quiz_assignments)
    assert_equal @quiz_assignment, assigns(:quiz_assignments).first
    assert_equal 1, assigns(:quiz_assignments).count

    assert assigns(:completed)
    assert_equal @quiz_assignment_completed, assigns(:completed).first
    assert_equal 1, assigns(:completed).count
  end

end
