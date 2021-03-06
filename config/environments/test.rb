Rails.application.configure do
  config.cache_classes = true
  config.eager_load = false

  config.serve_static_files   = false
  config.static_cache_control = 'public, max-age=3600'

  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false

  config.action_dispatch.show_exceptions = false
  config.action_controller.allow_forgery_protection = false
  config.active_support.deprecation = :stderr

  config.assets.debug = true

  ENV['APP_URL'] = 'http://test.host'
  ENV['SEGMENT_KEY'] = 'segment-write-key'
end
