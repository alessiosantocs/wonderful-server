# UserNotifications are created and then delivered to users
class UserNotification < ActiveRecord::Base
  belongs_to :user
  belongs_to :notification

  def to_push_notification(options={})

    # User and its token must be present // Notification and its message must be present
    if self.user && self.user.push_notification_token && self.notification && self.notification.message
      token = self.user.push_notification_token
      message = self.notification.message

      notification = Houston::Notification.new(device: token)
      notification.alert = message

      notification.sound = "sosumi.aiff"
      notification.content_available = true if options[:content_available]
      notification.custom_data = options[:custom_data] if options[:custom_data]

      return notification
    else
      return nil
    end

  end

  def deliver(options={})

    # If you can cast into a notification then you can send
    if push_notification = self.to_push_notification(options)
      WonderfulServer::Application::APN.push push_notification

      if push_notification.error
        return false
      else
        return true
      end
    end

  end

end
