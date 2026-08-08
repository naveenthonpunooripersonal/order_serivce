Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.keep_original_rails_log = false
  config.lograge.base_controller_class = 'ActionController::API'
  config.lograge.formatter = Lograge::Formatters::Json.new
  config.lograge.custom_options = lambda do |event|
    {
      time: Time.current.iso8601,
      host: event.payload[:host],
      remote_ip: event.payload[:remote_ip],
      request_id: event.payload[:request_id],
      # Add application-specific metadata:
      environment: Rails.env
    }
  end

end