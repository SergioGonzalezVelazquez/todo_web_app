class AddNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.integer :user_id, null: false
      t.integer :project_id, null: false
      t.string :text
      t.integer :notification_type
      t.boolean :pending

      t.timestamps
    end
  end
end
