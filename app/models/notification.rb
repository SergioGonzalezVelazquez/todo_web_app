class Notification < ApplicationRecord
  # Declare notification type as enum attribute
  enum type: [:collection_sharing]

  # Linking notification to user
  belongs_to :user
end
