class Task < ApplicationRecord

    # Declare priority enum attribute
    enum priority: [:high, :medium, :low]

    # Ensure that all tasks have a name
    validates :name, presence: true

    # Ensure that all tasks have a priority
    validates :priority, presence: true
end
