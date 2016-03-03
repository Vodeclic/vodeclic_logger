require "vodeclic/logger/version"

module Vodeclic
  autoload :AppLogging, 'vodeclic/logger/app_logging'
  autoload :LogFormatter, 'vodeclic/logger/log_formatter'
  autoload :LoggingPayload, 'vodeclic/logger/logging_payload'
  autoload :GrapeLogSubscriber, 'vodeclic/logger/grape_log_subscriber'

  if defined?(Rails)
    class Railtie < ::Rails::Railtie
      config.vodeclic = Vodeclic
      initializer "vodeclic.logger" do
        Vodeclic::AppLogging.init(config: Rails.application.config)
      end
    end
  end
end
