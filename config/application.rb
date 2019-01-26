require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SecretubeCom
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # 默认显示中文
    config.i18n.default_locale = :zh
    config.i18n.fallbacks = [:zh, :en]

    config.time_zone = "Asia/Shanghai"

    config.autoload_paths << "#{Rails.root}/app/utilities"

    # --skip-coffee
    config.generators.javascript_engine = :js
  end
end
