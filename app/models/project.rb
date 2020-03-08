class Project < ApplicationRecord

    # Ensure that all projects have a name
    validates :name, presence: true

    # Project has many tasks.
    # If you delete a project, its associated tasks will also be deleted
    has_many :tasks, dependent: :destroy

end
