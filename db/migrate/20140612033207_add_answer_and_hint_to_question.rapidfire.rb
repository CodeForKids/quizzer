# This migration comes from rapidfire (originally 20140612013326)
class AddAnswerAndHintToQuestion < ActiveRecord::Migration
  def change
    change_table :rapidfire_questions do |t|
      t.string :answer, :default => ''
      t.string :hint, :default => ''
    end
  end
end
