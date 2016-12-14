require File.expand_path('../boot', __FILE__)

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
Bundler.require(*Rails.groups)

module Checker
  class Application < Rails::Application
    config.api_only = true
    # https://github.com/rails-api/rails-api/issues/72
    config.secret_key_base = "we don't need this"
  end
end
