class AddAuthorToProjects < ActiveRecord::Migration[6.0]
  def change
    add_reference :projects, :author, index: true
    add_foreign_key :projects, :users, column: :author_id
  end
end
