class AddStatusToUserNotification < ActiveRecord::Migration
  def change
    add_column :user_notifications, :status, :integer
  end
end
