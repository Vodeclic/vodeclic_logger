require "active_support/concern.rb"

module Vodeclic
  module LoggingPayload
    extend ::ActiveSupport::Concern

    included do
      def append_info_to_payload(payload)
        super
        headers = request.headers
        payload[:request_uuid] = request.uuid
        payload[:parent_request_uuid] = headers["Parent-Request-Id"]
        payload[:parent_request_service] = headers["Parent-Request-Service"]
        payload[:parent_request_controller] = headers["Parent-Request-Controller"]
        payload[:parent_request_method] = headers["Parent-Request-Method"]
      end
    end

  end
end
