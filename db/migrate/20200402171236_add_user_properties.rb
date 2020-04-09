class AddUserProperties < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :surname, :string
    add_column :users, :username, :string
  end
end
