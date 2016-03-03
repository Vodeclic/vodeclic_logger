require "lograge"

module Vodeclic
  module AppLogging
    class << self
      attr_accessor :enabled

      def init(config:)
        return false if self.enabled != true
        init_lograge(config) 
      end

      def config
        yield(self)
      end

      protected
      def init_lograge(config)
        config.lograge.enabled = true
        config.lograge.formatter = ::Lograge::Formatters::Json.new
        config.lograge.custom_options = lambda do |event|
          payload = event.payload

          params = payload[:params]
            .reject { |k| %w(controller action).include?(k) }

          { 
            params: params,
            request_uuid: payload[:request_uuid],
            parent_request_uuid: payload["Parent-Request-Id"],
            parent_request_service: payload["Parent-Request-Service"],
            parent_request_controller: payload["Parent-Request-Controller"],
            parent_request_method: payload["Parent-Request-Method"],
          }
        end
        init_rails_logger(config) 
      end

      def init_rails_logger(config)
        path = config.paths["log"].first

        unless File.exist?(File.dirname(path))
          FileUtils.mkdir_p(File.dirname path)
        end

        if block_given? 
          yield(config, path)
        else
          logger = ::Logger.new(path)
          logger.formatter = LogFormatter.new
          config.logger = ::ActiveSupport::TaggedLogging.new(logger)
          logger.level  = ::ActiveSupport::BufferedLogger.const_get(config.log_level.to_s.upcase)
          ::Rails.logger = config.logger
          ::ActiveRecord::Base.logger = Rails.logger
        end
      end
    end
  end
end
