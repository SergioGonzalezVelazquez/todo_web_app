class CreateCollaborators < ActiveRecord::Migration[6.0]
  def change
    create_table :collaborators  do |t|
      t.belongs_to :user, index: true
      t.belongs_to :project, index: true
      t.integer :status
    end
  end
end
