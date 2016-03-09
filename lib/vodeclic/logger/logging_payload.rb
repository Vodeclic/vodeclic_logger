require "active_support/concern.rb"

module Vodeclic
  module LoggingPayload
    extend ::ActiveSupport::Concern

    included do
      def append_info_to_payload(payload)
        super
        headers = request.headers
        payload[:request_uuid] = request.uuid
        payload[:parent_request] = logging_parent_request(headers)
        payload[:session] = request.session
      end

      def logging_parent_request(headers)
        return {} unless headers["Parent-Request"]
        JSON.parse(headers["Parent-Request"]) rescue {}
      end
    end

  end
end
