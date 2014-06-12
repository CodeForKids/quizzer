class AddSourceToQuizAssignment < ActiveRecord::Migration
  def change
    add_column :quiz_assignments, :source, :string, default: ''
  end
end
