Bugsnag.configure do |config|
  config.api_key = ENV['BUGSNAG_API_KEY']
end if ENV['BUGSNAG_API_KEY'].present? && Rails.env.production?
