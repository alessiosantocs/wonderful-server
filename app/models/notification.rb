# The admin creates new notifications
class Notification < ActiveRecord::Base
  has_many :user_notifications
  has_many :users, through: :user_notifications

  # after_create :deliver

  def deliver
    users = User.notifiable

    users.each do |user|
      user.assign_and_deliver_notification(self)
    end
  end
end
