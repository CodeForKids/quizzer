require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  setup do
    @admin = create(:admin)
    @kid = create(:kid)

    setup_answers
  end

  test 'gravatar' do
    assert_equal 'https://www.gravatar.com/avatar.php?gravatar_id=7d88a4641924c30ad59ba00b200bbd5f', gravatar(@admin.email)
  end

  test 'checkbox_checked?' do
    assert checkbox_checked?(@answer, "d")
    assert_not checkbox_checked?(@answer, "e")
  end

end
