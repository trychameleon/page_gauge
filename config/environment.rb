require File.expand_path('../application', __FILE__)

Rails.application.initialize!
Rails.application.routes.default_url_options[:host] = ENV['APP_URL']
