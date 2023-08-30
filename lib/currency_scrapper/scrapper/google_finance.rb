# frozen_string_literal: true

require_relative 'generic_scrapper'

module CurrencyScrapper
  # Scrapper for Google Finance
  class GoogleFinanceScrapper < CurrencyScrapper::GenericScrapper
    XPATH_CURRENCY_CLASS = 'YMlKec fxKbKc'
    XPATH_TIMESTAMP_IDENTIFIER = 'Vebqub'

    def initialize(base_currency:, target_currency:)
      super(base_url: 'https://www.google.com/finance/quote/')
      @base_currency = base_currency.to_s.upcase
      @target_currency = target_currency.to_s.upcase
    end

    def currency_path
      "#{@base_currency}-#{@target_currency}"
    end

    def retrieve_currency_data
      converted_html = convert_html(html_data)
      parsed_data = safely_parse(converted_html)
      sell_value = parsed_data[:sell_value]
      timestamp = parsed_data[:timestamp]

      quote_data(base_currency: @base_currency, target_currency: @target_currency,
                 sell_value:, timestamp:)
    end

    def safely_parse(converted_html)
      raise CurrencyNotFound if converted_html.text.include?("We couldn't find any match for your search")

      raise DataNotFound if converted_html.nil? || converted_html.text.empty?

      currency_value = converted_html.xpath("//div[@class=\"#{XPATH_CURRENCY_CLASS}\"]")&.text
      timestamp = converted_html.xpath("//div[@jsname=\"#{XPATH_TIMESTAMP_IDENTIFIER}\"]")&.text&.split(' · ')&.first

      { sell_value: currency_value,
        timestamp: }
    end
  end
end
