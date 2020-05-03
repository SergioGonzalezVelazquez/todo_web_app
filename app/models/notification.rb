class Notification < ApplicationRecord
  # Declare notification type as enum attribute
  enum notification_type: [:invitation, :new_user, :new_task, :task_completed, :user_abandon]

  # Linking notification to user
  belongs_to :user

  belongs_to :project
end
