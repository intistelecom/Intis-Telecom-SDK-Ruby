require "json"

module Intis::Sdk
  class UrlHelper
    def self.parse_data(response)
      response_body = JSON.parse(response.body, symbolize_names: true)
      validate_response! response_body
      
      response_body
    end

    def self.validate_response!(response_body)
      if !response_body.kind_of?(Array) and response_body.has_key? :error
        response_error = response_body[:error]
        raise("Error. Error code: #{response_error}")
      end
    end
	end
end