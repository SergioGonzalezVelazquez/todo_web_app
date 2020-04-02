class AddUserAssociationToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :user_id, :integer
    add_index   :projects, :user_id
  end
end
