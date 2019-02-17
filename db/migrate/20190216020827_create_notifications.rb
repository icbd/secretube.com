class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.integer :user_id, null: false
      t.string :content, null: false
      t.integer :category, null: false
      t.integer :status, null: false, default: 1
      t.text :description, comment: 'response message'

      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
