redis_url = ENV.fetch("REDIS_URL", "redis://localhost:6379/0")

# Configure order_service exclusively as a job producer (Client)
Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end

# Server configuration removed since Sidekiq worker lives in the worker microservice