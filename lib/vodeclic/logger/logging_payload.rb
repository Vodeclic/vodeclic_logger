require "active_support/concern.rb"

module Vodeclic
  module LoggingPayload
    extend ::ActiveSupport::Concern

    included do
      def append_info_to_payload(payload)
        super
        headers = request.headers
        payload[:request_uuid] = request.uuid
        payload[:parent_request] = headers["Parent-Request"] || {}
        payload[:session] = request.session
      end
    end

  end
end
