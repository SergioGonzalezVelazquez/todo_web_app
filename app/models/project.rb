class Project < ApplicationRecord

    # Ensure that all projects have a name
    validates :name, presence: true

end
