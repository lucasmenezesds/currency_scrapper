# frozen_string_literal: true

require_relative 'generic_scrapper'

module CurrencyScrapper
  # Scrapper for Investing Dot Com
  class InvestingDotCom < CurrencyScrapper::GenericScrapper
    XPATH_BID_ASK_IDENTIFIER = 'bid-value'
    XPATH_CURRENCY_IDENTIFIER = 'instrument-price-last'
    XPATH_PREV_CLOSE_IDENTIFIER = 'prev-close-value'
    XPATH_DAYS_RANGE_IDENTIFIER = 'range-value'
    XPATH_TIMESTAMP_CLASS = 'instrument-metadata_time__fopxP'

    class << self
      def quote_currency(base_currency, target_currency)
        CurrencyScrapper::InvestingDotCom.new(base_currency:, target_currency:).retrieve_currency_data
      end
    end

    def initialize(base_currency:, target_currency:)
      super(base_url: 'https://www.investing.com/currencies/')
      @base_currency = base_currency.to_s.downcase.tr('^a-z', '')
      @target_currency = target_currency.to_s.downcase.tr('^a-z', '')
    end

    def retrieve_currency_data
      response_body = request_data.body
      converted_html = convert_html(response_body)
      parsed_data = safely_parse(converted_html)
      sell_value = parsed_data.fetch(:sell_value, 0).to_f
      buy_value = parsed_data.fetch(:bid_ask, '').split('/').first.to_f
      previous_close_value = parsed_data.fetch(:prev_close, 0).to_f
      days_range = parsed_data.fetch(:days_range, nil)
      timestamp = normalize_timestamp(parsed_data.fetch(:timestamp, nil))

      quote_data(base_currency: @base_currency, target_currency: @target_currency,
                 buy_value:, previous_close_value:, days_range:, sell_value:, timestamp:)
    end

    def normalize_timestamp(timestamp)
      return if timestamp.nil?

      Time.parse(timestamp).strftime('%b %e,%l:%M:%S %p UTC')
    end

    private

    def request_data
      uri_parser = URI::Parser.new
      escaped_uri = uri_parser.escape(File.join(@base_url, currency_path).to_s)
      request_data = HTTParty.get(escaped_uri)

      raise CurrencyNotFound if request_data.code == 404

      raise UnsuccessfulRequest if request_data.code != 200 || request_data.response.body.empty?

      request_data
    end

    def currency_path
      "#{@base_currency}-#{@target_currency}"
    end

    def safely_parse(converted_html)
      raise DataNotFound if converted_html.nil? || converted_html.text.empty?

      raise CurrencyNotFound if converted_html.text.include?("Seems like the page you were looking for isn't here")

      sell_value = converted_html.xpath("//span[@data-test=\"#{XPATH_CURRENCY_IDENTIFIER}\"]").text
      bid_ask = converted_html.xpath("//div[@data-test=\"#{XPATH_BID_ASK_IDENTIFIER}\"]").text
      prev_close = converted_html.xpath("//div[@data-test=\"#{XPATH_PREV_CLOSE_IDENTIFIER}\"]").text
      days_range = converted_html.xpath("//div[@data-test=\"#{XPATH_DAYS_RANGE_IDENTIFIER}\"]").text
      timestamp = converted_html.xpath("//div[contains(@class, \"#{XPATH_TIMESTAMP_CLASS}\")]//time").attr('datetime')&.value

      { sell_value:, bid_ask:, prev_close:, days_range:, timestamp: }
    end
  end
end
