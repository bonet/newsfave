source 'https://rubygems.org'

ruby "2.0.0"

gem 'rails', '3.2.12'

gem 'rake'
gem 'gravatar_image_tag'
gem "cocaine"
gem "paperclip"
gem "aws-s3",            :require => "aws/s3"
gem 'aws-sdk', '~> 1.3.4'
gem 'curb'
gem 'foreman'
gem 'jquery-rails'
gem 'figaro'
gem 'devise'
gem 'pg'

gem 'coveralls', require: false

group :production do
  gem 'newrelic_rpm'
  gem 'unicorn'
end

group :development, :test do
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
  gem 'rspec-rails'
  gem 'mongoid-rspec'
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'capybara-webkit' # need to install qt first: `brew install qt`
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'mailcatcher'
end

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end
