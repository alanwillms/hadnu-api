class Rack::Attack
  # `Rack::Attack` is configured to use the `Rails.cache` value by default,
  # but you can override that by setting the `Rack::Attack.cache.store` value
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  # Allow all local traffic
  whitelist('allow-localhost') do |req|
    '127.0.0.1' == req.ip || '::1' == req.ip
  end

  # Allow an IP address to make "limit" requests every "period" seconds
  throttle('req/ip', limit: 120, period: 120) do |req|
    req.ip unless req.path.starts_with?('/system')
  end

  # Send the following response to throttled clients
  self.throttled_response = -> (env) {
    retry_after = (env['rack.attack.match_data'] || {})[:period]
    [
      429,
      {
        'Content-Type' => 'application/json',
        'Retry-After' => retry_after.to_s
      },
      [{ error: 'Throttle limit reached. Retry later.' }.to_json]
    ]
  }
end
