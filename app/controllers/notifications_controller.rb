class NotificationsController < ApplicationController
  def index
    @all_notifications = Notification.all.order(created_at: :desc)
  end
end
