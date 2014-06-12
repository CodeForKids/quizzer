class CreateQuizAssignments < ActiveRecord::Migration
  def change
    create_table :quiz_assignments do |t|
      t.references :user
      t.references :question_group
      t.boolean :completed, default: false
      t.integer :attempts, default: 0
      t.timestamps
    end
  end
end
