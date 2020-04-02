class Task < ApplicationRecord

    # Declare priority enum attribute
    enum priority: [:high, :medium, :low]

    # Ensure that all tasks have a name
    validates :name, presence: true

    # Ensure that all tasks have a priority
    validates :priority, presence: true

    # A task is created by a user
    belongs_to :user

    # Sets up an Active Record association: a task can belong to a project
    belongs_to :project, optional: true

end
