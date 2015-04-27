json.array!(@notifications) do |notification|
  json.extract! notification, :id, :message
  json.url notification_url(notification, format: :json)

  if @user
    json.user_notification do
      json.extract! notification.user_notifications.for_user(@user).first, :id, :created_at, :updated_at, :status, :is_loved
    end
  end
end
