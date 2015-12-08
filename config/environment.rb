require File.expand_path('../application', __FILE__)

Rails.application.initialize!
Rails.application.routes.default_url_options[:host] = ENV['APP_URL']

ActiveSupport::JSON::Encoding.escape_html_entities_in_json = false
