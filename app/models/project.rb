class Project < ApplicationRecord

    # Ensure that all projects have a name
    validates :name, presence: true

    # Project has many tasks.
    # If you delete a project, its associated tasks will also be deleted
    has_many :tasks, dependent: :destroy

    # Linking projects to users
    belongs_to :author, class_name: "User"

end
