class AddLovedAtToUserNotification < ActiveRecord::Migration
  def change
    add_column :user_notifications, :loved_at, :date
  end
end
