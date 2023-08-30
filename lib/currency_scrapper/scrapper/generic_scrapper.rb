# frozen_string_literal: true

require 'httparty'
require 'nokogiri'

module CurrencyScrapper
  # Generic Scrapper that is used as base for the custom scrappers
  class GenericScrapper
    def initialize(base_url:)
      @base_url = base_url
    end

    def html_data
      request_data = HTTParty.get(File.join(@base_url, currency_path).to_s)

      raise UnsuccessfulRequest if request_data.code != 200 || request_data.response.body.empty?

      request_data
    end

    def convert_html(html_data)
      Nokogiri::HTML(html_data)
    end

    # rubocop: disable Metrics/ParameterLists
    def quote_data(sell_value:, base_currency:, target_currency:, timestamp:, buy_value: nil, days_range: nil, previous_close_value: nil)
      result = {
        sell_value:,
        base_currency:,
        target_currency:,
        timestamp:
      }

      result[:buy_value] = buy_value if buy_value # Bid Value
      result[:previous_close_value] = previous_close_value if previous_close_value
      result[:days_range] = days_range if days_range

      result
    end

    # rubocop: enable Metrics/ParameterLists

    def currency_path
      raise 'currency_path method must be implemented in subclass'
    end

    def retrieve_currency_data
      raise 'retrieve_currency_data method must be implemented in subclass'
    end
  end
end
