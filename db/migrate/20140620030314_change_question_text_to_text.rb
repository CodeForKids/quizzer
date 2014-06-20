class ChangeQuestionTextToText < ActiveRecord::Migration
  def up
    change_column :rapidfire_questions, :question_text, :text
end
def down
    # This might cause trouble if you have strings longer
    # than 255 characters.
    change_column :rapidfire_questions, :question_text, :string
end
end
