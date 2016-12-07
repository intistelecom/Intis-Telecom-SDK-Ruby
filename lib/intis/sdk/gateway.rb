require "intis/sdk/url_helper"
require "net/http"
require "openssl"
require "json"
require 'digest'

module Intis::Sdk
  class Gateway
  	def initialize(config)
      @config = config
    end

    def request(path, params = {})
      url = URI.parse("https://#{@config[:api_host]}/external#{path}")

	  	http = Net::HTTP.new(url.host, url.port)

	  	http.read_timeout = 15
			http.open_timeout = 15
			http.use_ssl = true
			http.verify_mode = OpenSSL::SSL::VERIFY_NONE

			headers = {}

			params[:login] = @config[:login]
			params[:timestamp] = Time.now.to_i

			signature = Digest::MD5.hexdigest(params.sort.map{|k,v| v}.join + @config[:api_key])
			params[:signature] = signature

			url_params = ""
	    url_params += URI.encode_www_form(params) if params.any?

			req = Net::HTTP::Get.new(url.path + "?" + url_params, headers)

			response = http.start() {|http| http.request(req) }

			if response.kind_of?(Net::HTTPSuccess)
	  		return UrlHelper.parse_data(response)
	  	else
        raise response.inspect
	  	end
    end
  end
end