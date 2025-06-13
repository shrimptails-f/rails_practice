require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Myappモジュールはアプリケーション全体の名前空間を定義します。
module Myapp
  # ApplicationクラスはRailsアプリケーションの設定を定義します。
  class Application < Rails::Application
    config.load_defaults 7.1
    config.api_only = true
  end
end
