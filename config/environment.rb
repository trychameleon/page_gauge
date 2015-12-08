require File.expand_path('../application', __FILE__)

Rails.application.initialize!
Rails.application.routes.default_url_options[:host] = ENV['APP_URL']

chars = ActiveSupport::JSON::Encoding::JSONGemEncoder.const_get(:ESCAPED_CHARS) # ouch

##
# Originally saw `JSON::GeneratorError·source sequence is illegal/malformed utf-8`
#   The source of the problem was html site body that we send via JSON
#
#   The fix is to not escape those characters, which can be done in a few ways (this is one).
#
chars.delete('<')
chars.delete('>')
chars.delete('&')
