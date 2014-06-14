class AddDeviseOptionstoUser < ActiveRecord::Migration
  def up
    change_table :users do |t|
      # Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      # Rememberable
      t.datetime :remember_created_at
    end
    add_index :users, :reset_password_token, :unique => true
  end

  def down
    remove_column :users, :reset_password_token
    remove_column :users, :reset_password_sent_at
    remove_column :users, :remember_created_at
  end
end
