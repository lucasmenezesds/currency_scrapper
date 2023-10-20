# frozen_string_literal: true

require_relative 'generic_scrapper'

module CurrencyScrapper
  # Scrapper for Google Finance
  class GoogleFinance < CurrencyScrapper::GenericScrapper
    XPATH_CURRENCY_CLASS = 'YMlKec fxKbKc'
    XPATH_TIMESTAMP_IDENTIFIER = 'Vebqub'

    class << self
      def quote_currency(base_currency, target_currency)
        CurrencyScrapper::GoogleFinance.new(base_currency:, target_currency:).retrieve_currency_data
      end

      alias quote quote_currency
    end

    def initialize(base_currency:, target_currency:)
      super(base_url: 'https://www.google.com/finance/quote/')
      @base_currency = base_currency.to_s.upcase.tr('^A-Z', '')
      @target_currency = target_currency.to_s.upcase.tr('^A-Z', '')
    end

    def retrieve_currency_data
      response_body = request_data.body
      converted_html = convert_html(response_body)
      parsed_data = safely_parse(converted_html)
      sell_value = parsed_data.fetch(:sell_value, 0).to_f
      timestamp = parsed_data.fetch(:timestamp, nil) # Google Format: '%b%e,%l:%M:%S %p UTC'

      quote_data(base_currency: @base_currency, target_currency: @target_currency,
                 sell_value:, timestamp:)
    end

    private

    def currency_path
      "#{@base_currency}-#{@target_currency}"
    end

    def safely_parse(converted_html)
      raise DataNotFound if converted_html.nil? || converted_html.text.empty?

      raise CurrencyNotFound if converted_html.text.include?("We couldn't find any match for your search")

      currency_value = converted_html.xpath("//div[@class=\"#{XPATH_CURRENCY_CLASS}\"]").text
      timestamp = converted_html.xpath("//div[@jsname=\"#{XPATH_TIMESTAMP_IDENTIFIER}\"]").text.split(' · ').first
      timestamp = timestamp&.gsub(' ', ' ')

      { sell_value: currency_value,
        timestamp: }
    end
  end
end
