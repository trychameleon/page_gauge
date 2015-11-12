source 'https://rubygems.org'
ruby '2.2.2'

gem 'rails', '~> 4.2'
gem 'sass-rails'
gem 'mongoid', '~> 5'
gem 'puma'

gem 'bugsnag'

gem 'sidekiq'

gem 'analytics-ruby', :require => 'segment'
gem 'slack-notifier'

gem 'jquery-rails'
gem 'bootstrap-sass'

group :assets do
  gem 'uglifier'
end

group :production do
  gem 'rails_12factor'
end

group :test do
  gem 'timecop'
  gem 'rspec-rails'
  gem 'rspec-its'
  gem 'mock_redis'
  gem 'webmock'
  gem 'capybara'
  gem 'poltergeist'
  gem 'selenium-webdriver'
  gem 'factory_girl'
end
