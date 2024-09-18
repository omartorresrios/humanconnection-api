class NotificationsController < ApplicationController

  before_action :authorized

  def mark_all_as_read
    unreadNotifications = Notification.where(recipient: current_user).unread
    unreadNotifications.update_all(read_at: Time.zone.now)
    render nothing: true, status: 204
  end
end