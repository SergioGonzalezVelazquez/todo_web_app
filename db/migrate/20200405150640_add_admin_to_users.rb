class AddAdminToUsers < ActiveRecord::Migration[6.0]
  def change
    # ensure that users aren’t accidentally created as admins.
    add_column :users, :admin, :boolean, default: false
  end
end
