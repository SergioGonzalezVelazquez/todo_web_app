class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :activities do |t|
      t.integer :user_id, null: false
      t.string :text
      t.integer :type
    end
  end
end
