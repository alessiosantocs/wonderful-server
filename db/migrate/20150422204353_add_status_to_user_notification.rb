class AddStatusToUserNotification < ActiveRecord::Migration
  def change
    add_column :user_notifications, :status, :integer, :default => 0
  end
end
