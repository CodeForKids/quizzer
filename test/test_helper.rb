ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/mini_test'
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
  include FactoryGirl::Syntax::Methods

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  def setup_answers
    @question_group = create(:question_group)
    @question_group_2 = create(:question_group)

    @question = create(:q_checkbox, answer: 'd', answer_options: "d\r\ne\r\nb", question_group: @question_group)
    @question_2 = create(:q_checkbox, answer: 'b', answer_options: "d\r\ne\r\nb", question_group: @question_group_2)

    @answer_group = create(:answer_group, question_group: @question_group)
    @answer_group_2 = create(:answer_group, question_group: @question_group_2)

    @answer = create(:answer, answer_group: @answer_group, question: @question, answer_text: "d")
    @answer_2 = create(:answer, answer_group: @answer_group_2, question: @question_2, answer_text: "e")
  end
end

class ActionController::TestCase
  include Devise::TestHelpers
end
