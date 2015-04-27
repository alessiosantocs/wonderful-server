namespace :user_notifications do

  desc "Sets default status to user_notifications for those who have nil"
  task :set_sent_where_nil => :environment do
    user_notifications = UserNotification.where("user_notifications.status IS NULL")

    user_notifications.update_all status: UserNotification::STATUSES[:SENT]
  end
end
