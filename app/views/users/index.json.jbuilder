json.array!(@users) do |user|
  json.extract! user, :id, :push_notification_token, :device_uuid
  json.url user_url(user, format: :json)
end
