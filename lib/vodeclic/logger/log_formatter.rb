# encoding: utf-8
require "active_support/core_ext/logger.rb"

module Vodeclic
  class LogFormatter < ::Logger::SimpleFormatter
    def call(severity, timestamp, progname, data)
      { 
        type: severity,
        time: timestamp,
        message: message(data)
      }.to_json.concat("\n")
    end


    def message(data)
      begin
        JSON.parse(data)
      rescue JSON::ParserError => e
        { data: data }
      end
    end
  end
end
