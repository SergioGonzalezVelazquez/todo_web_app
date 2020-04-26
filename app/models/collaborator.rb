class Collaborator < ApplicationRecord
  # Declare collaborator status as enum attribute
  enum status: [:pending, :accepted, :revoked, :denied]

  belongs_to :user
  belongs_to :project
end
