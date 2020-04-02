class AddUserAssociationToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :user_id, :integer
    add_index   :tasks, :user_id
  end
end
