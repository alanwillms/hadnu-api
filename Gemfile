source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>= 5.0', '< 5.1'

# PostgreSQL driver
gem 'pg'

# Use Puma as the app server
gem 'puma', '~> 3.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.0'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

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
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
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
