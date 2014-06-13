require 'test_helper'

class UserHelperTest < ActionView::TestCase
  setup do
    setup_answers
  end

  test 'average_of_groups' do
    assert_equal 50.0, average_of_groups([@answer_group, @answer_group_2])
    assert_equal 100.0, average_of_groups([@answer_group])
    assert_equal 0.0, average_of_groups([@answer_group_2])
  end
end
