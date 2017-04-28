source 'https://rubygems.org'

# Ruby on Rails
gem 'rails', '>= 5.1', '< 5.2'

# PostgreSQL driver
gem 'pg'

# Use Puma as the app server
gem 'puma'

# Handle Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

# Rate Limiting and Throttling
gem 'rack-attack'

# Which attributes will be shown in APIs
gem 'active_model_serializers'

# Lists pagination
gem 'kaminari'
gem 'api-pagination'

# JWT Authentication
gem 'knock'

# Oauth2 Authentication with Facebook via Signed Request + Oauth Token
# (Omniauth requires sessions, so it has been discarded)
gem 'koala'

# Mime Types
gem 'mime-types'

# Authorization policies
gem 'pundit'

# CKEditor uploads back-end
gem 'paperclip'

# ReCaptcha validation
gem 'recaptcha'

# I18n
gem 'rails-i18n', '~> 5.0.0'

# Validators
gem 'date_validator'
gem 'email_validator', require: 'email_validator/strict'
gem 'activemodel-ipaddr_validator'

# Environment variables
gem 'dotenv-rails'

# Profiling
gem 'skylight'

# Log tracking
gem 'airbrake', '~> 5.6'

group :development, :test do
  # Call 'byebug' in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'bullet'
end

group :development do
  gem 'listen'
  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'
end

group :test do
  gem 'simplecov', require: false
  gem 'faker'
  gem 'shoulda-matchers'
  gem 'email_spec'
  gem 'codeclimate-test-reporter', '~> 1.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
