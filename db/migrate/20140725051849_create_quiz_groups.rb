class CreateQuizGroups < ActiveRecord::Migration
  def change
    create_table :quiz_groups do |t|
      t.string  :name
      t.timestamps
    end
    add_index :quiz_groups, :name

    change_table :rapidfire_question_groups do |t|
      t.references :quiz_group
    end
  end
end
