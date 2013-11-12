source 'https://rubygems.org'

gem 'rails', '3.2.12'

gem 'rb-readline'

gem 'rake'

gem 'gravatar_image_tag'

gem "cocaine"
gem "paperclip"

gem "aws-s3",            :require => "aws/s3"

gem 'aws-sdk', '~> 1.3.4'

gem 'curb'

gem 'foreman'

group :production do
  gem 'pg'
  gem 'newrelic_rpm'
  gem 'unicorn'
end

group :development, :test do
  gem 'sqlite3'
  gem 'figaro'
  
  gem 'rspec-rails'
  
  gem 'mongoid-rspec'
  
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'guard-spork'
  
  gem 'factory_girl_rails'

  gem 'simplecov'
end

group :development do
  gem 'thin'
  
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry-rails'
  gem 'colorize'

  gem 'rb-fchange', :require => false
  gem 'rb-fsevent', '~> 0.9.2'
  gem 'rb-inotify', :require => false
  gem 'rb-readline', :require => false
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  #gem 'terminal-notifier-guard' # OSX 10.8
  gem 'mailcatcher'
end

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
