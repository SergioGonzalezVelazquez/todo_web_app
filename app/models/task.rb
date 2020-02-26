class Task < ApplicationRecord

    # Ensure that all tasks have a name
    validates :name, presence: true
end
