require "active_support/concern.rb"

module Vodeclic
  module LoggingPayload
    extend ::ActiveSupport::Concern

    included do
      def append_info_to_payload(payload)
        super
        headers = request.headers
        payload[:request_uuid] = request.uuid
        payload[:parent_request_uuid] = headers["Parent-Request-Id"] unless headers["Parent-Request-Id"].nil?
        payload[:parent_request_service] = headers["Parent-Request-Service"] unless headers["Parent-Request-Service"].nil?
        payload[:parent_request_controller] = headers["Parent-Request-Controller"] unless headers["Parent-Request-Controller"].nil?
        payload[:parent_request_method] = headers["Parent-Request-Method"] unless headers["Parent-Request-Method"].nil?
      end
    end

  end
end
