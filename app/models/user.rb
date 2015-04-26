# The user signs up for receiving notifications
class User < ActiveRecord::Base

  has_many :user_notifications
  has_many :notifications, through: :user_notifications

  scope :notifiable, lambda {where("users.push_notification_token IS NOT NULL")}

  def send_push_notification(message, options={})
    if self.push_notification_token.present? && message.present?
      notification = Houston::Notification.new(device: self.push_notification_token)
      notification.alert = message

      notification.sound = "sosumi.aiff"
      notification.content_available = true if options[:content_available]
      notification.custom_data = options[:custom_data] if options[:custom_data]

      WonderfulServer::Application::APN.push notification
    else
      # raise "There is no push notification token for user (id=#{self.id})"
    end
  end

  def assign_notification(notification)
    user_notification = self.user_notifications.create(:notification => notification)

    return user_notification
  end

  def assign_and_deliver_notification(notification)
    noti = self.assign_notification(notification)
    noti.deliver
  end
end
