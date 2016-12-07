require "intis/sdk/gateway"

module Intis::Sdk
  # The main class for SMS sending and getting API information
  class Client

    # A new API client.
    # @param config [Hash] hash with keys: login, api_key, api_host.
    def initialize(config = {})
      @config = {
        login: nil,
        api_key: nil,
        api_host: nil
      }.merge(config)

      raise "Login can't be empty" if @config[:login].nil?
      raise "Api key can't be empty" if @config[:api_key].nil?
      raise "Api host can't be empty" if @config[:api_host].nil?

      @gateway = Gateway.new @config
    end

    # Balance request.
    # @return [Hash] response.
    def get_balance
      @gateway.request("/get/balance.php")
    end

    # Lists request.
    # @return [Hash] response.
    def get_base
      @gateway.request("/get/base.php")
    end

    # Request for senders list.
    # @return [Hash] response.
    def get_senders
      @gateway.request("/get/senders.php")
    end

    # Request for numbers from list.
    # @param base [String] List ID.
    # @param page [Integer] Page number.
    # @return [Hash] response.
    def get_phone base, page = 1
      @gateway.request("/get/phone.php", base: base, page: page)
    end

    # Status request.
    # @param state [String] status ID. If you need statuses of several SMS, you should specify ID separated by commas.
    # @return [Hash] response.
    def get_status state
      @gateway.request("/get/state.php", state: state)
    end

    # SMS sending.
    # @param phone [String] One or several numbers separated by commas (no more than 100 numbers in the request).
    # @param text [String] Text of SMS message.
    # @param sender [String] Sender name (one of the approved in your account).
    # @param sending_time [String] Example: 2014-05-30 14:06 (an optional parameter, it is used when it is necessary to schedule SMS messages).
    # @return [Hash] response.
    def send phone, text, sender, sending_time = nil
      @gateway.request("/get/send.php", phone: phone, text: text, sender: sender, sendingTime: sending_time)
    end

    # Search in the black list.
    # @param phone [String] Required number.
    # @return [Hash] response.
    def find_on_stop phone
      @gateway.request("/get/find_on_stop.php", phone: phone)
    end

    # Adding a number to the stop list.
    # @param phone [String] Required number.
    # @return [Hash] response.
    def add_to_stop phone
      @gateway.request("/get/add2stop.php", phone: phone)
    end

    # Request for templates list.
    # @return [Hash] response.
    def get_template
      @gateway.request("/get/template.php")
    end

    # Adding a template.
    # @param name [String] Template name.
    # @param text [String] Template text.
    # @param override [Integer] - Example: 0 or 1 (an optional parameter; it is used for template editting, if the template you want to edit is found and the override parameter is 1, the template will be edited).
    # @return [Hash] response.
    def add_template name, text, override = 0
      @gateway.request("/get/add_template.php", name: name, text: text, override: override)
    end

    # Deleting a template.
    # @param name [String] Template name.
    # @return [Hash] response.
    def del_template name
      @gateway.request("/get/del_template.php", name: name)
    end

    # General statistics for a month by days.
    # @param month [String] Year and month in the format YYYY-MM.
    # @return [Hash] response.
    def get_stat_by_month month
      @gateway.request("/get/stat_by_month.php", month: month)
    end

    # HLR request.
    # @param phone [String] one or several numbers separated by commas, but no more than 100 numbers in the request.
    # @return [Hash] response.
    def hlr phone
      @gateway.request("/get/hlr.php", phone: phone)
    end

    # Statistics of HLR requests.
    # @param from [String] date of start in the format YYYY-MM-DD.
    # @param to [String] date of end in the format YYYY-MM-DD.
    # @return [Hash] response.
    def get_hlr_stat from, to
      @gateway.request("/get/hlr_stat.php", from: from, to: to)
    end

    # Mobile operator query.
    # @param phone [String] Phone number.
    # @return [Hash] response.
    def get_operator phone
      @gateway.request("/get/operator.php", phone: phone)
    end

    # Request for incoming SMS by date.
    # @param date [String] date in the format YYYY-MM-DD.
    # @return [Hash] response.
    def get_incoming_by_date date
      @gateway.request("/get/incoming.php", date: date)
    end

    # Request for incoming SMS by period.
    # @param from [String] date of start in the format YYYY-MM-DD HH:II:SS (Example: 2014-05-01 14:06:00).
    # @param to [String] date of end in the format YYYY-MM-DD HH:II:SS (Example: 2014-05-30 23:59:59).
    # @return [Hash] response.
    def get_incoming_by_period from, to
      @gateway.request("/get/incoming.php", from: from, to: to)
    end

    # Prices request.
    # @return [Hash] response.
    def get_prices
      @gateway.request("/get/prices.php")
    end
  end
end
