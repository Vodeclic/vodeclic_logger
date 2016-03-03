require "lograge"
module Vodeclic
  class GrapeLoggerSubscriber < ::Lograge::RequestLogSubscriber
    def request(event)
      return if ::Lograge.ignore?(event)
      payload = event.payload
      data = extract_request(event, payload)
      data = before_format(data, payload)
      formatted_message = data.to_json.concat("\n")
      logger.send(::Lograge.log_level, formatted_message)
    end

    def extract_path(payload)
      path = payload[:request_path]
      index = path.index('?')
      index ? path[0, index] : path
    end

    def initial_data(payload)
      {
        method: payload[:request_method],
        path: extract_path(payload),
      }
    end
  end
end
