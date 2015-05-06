
namespace :notifications do

  # PROBLEM =======

  # The user signs up
  # Accepts remote notifications and his token is updated
  # Ready to receive notifications

  # The admin creates notifications to be sent daily to users

  # The user will receive 1 notification in the morning at 8am wherever he is
  # He will never receive a notification he has already received

  # SOLUTION =======

  # We have
  # - Users
  # - Notifications
  # - UserNotifications # That are basically sent notifications

  # When the user signs up:
  # - Register the timezone of the user

  # A rake task that:
  # - For every user:
  #   - If he did not receive a notification that day
  #     - If it's around 8am depending on his timezone
  #       - Selects a Notification to send from the poll that the user hasn't already received
  #       - Sends it
  #       - Marks in the database the notification as sent
  desc "This task delivers notifications to users when it's time"

  task :deliver_daily_notifications => :environment do

    # Constants
    HOUR_OF_THE_DAY = 8
    DEFAULT_TIME_ZONE = "0"

    puts "Rake started at #{DateTime.now}"

    users = User.notifiable

    users.each do |user|
      puts "User ##{user.id}"

      # Has not received notifications today yet
      if user.user_notifications.where("DATE(user_notifications.created_at) = DATE(NOW())").empty?

        puts "- Has not received notification yet"

        time = DateTime.now.utc
        zone = user.time_zone || DEFAULT_TIME_ZONE
        zone = zone.to_i

        user_time = time + zone.hours

        puts "- User time is #{user_time}"

        if user_time.hour == HOUR_OF_THE_DAY

          already_sent_ids = user.notifications.map(&:id)

          already_sent_ids = [0] if already_sent_ids.empty? # Mysql would return an empty array fix

          sendable_notifications = Notification.where("notifications.id NOT IN (?)", already_sent_ids)

          # At least one sendable notification
          if sendable_notifications.any?
            sample_notification = sendable_notifications.sample

            puts " - Sending sample notification ##{sample_notification.id} => #{sample_notification.message}"
            user.assign_and_deliver_notification sample_notification
          else
            puts " - No unique sample notification for this user."

          end
        else
          puts "- Not the right time (#{HOUR_OF_THE_DAY})"
        end

      else
        puts "- Has already received notification today"
      end

    end

  end

end
