Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true

  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_files = true
  config.static_cache_control = 'public, max-age=31536000'
  config.asset_host = ENV['APP_URL']

  config.assets.js_compressor = :uglifier
  config.assets.css_compressor = :sass
  config.assets.compile = false
  config.assets.digest = true

  config.assets.version = '1.1'

  config.log_level = :info
  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify
end
