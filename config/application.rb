require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
# require 'sprockets/railtie'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HadnuApi
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # Add forms directory to the path
    config.autoload_paths += Dir[Rails.root.join('app', 'forms', '{*/}')]

    # CORS
    config.middleware.insert_before 0, 'Rack::Cors' do
      allow do
        origins 'www.hadnu.org', 'hadnu.org'
        resource(
          '*',
          headers: :any,
          methods: [:get, :post, :delete, :put, :patch, :options, :head],
          expose: ['Authorization', 'Content-Type', 'X-Total', 'X-Per-Page', 'X-Page']
        )
      end
    end

    # Rate Limiting and Throttling
    config.middleware.use Rack::Attack

    # I18n
    config.i18n.default_locale = 'pt-BR'
    config.i18n.available_locales = ['pt-BR', :en]
  end
end
