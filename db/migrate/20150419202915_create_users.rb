class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :push_notification_token
      t.text :device_uuid

      t.timestamps
    end
  end
end
