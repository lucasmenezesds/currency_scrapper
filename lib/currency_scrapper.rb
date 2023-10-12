# frozen_string_literal: true

require_relative 'currency_scrapper/version'
require_relative 'currency_scrapper/scrapper'
require_relative 'currency_scrapper/scrapper_error'

module CurrencyScrapper
  class Error < StandardError; end

  class CLI
    class << self
      def prettified_puts(quote_hash)
        puts "** #{quote_hash[:base_currency].upcase} => #{quote_hash[:target_currency].upcase} **"
        puts "Sell Value: #{quote_hash[:sell_value]}"
        puts "Buy Value: #{quote_hash[:buy_value]}" if quote_hash.fetch(:buy_value, nil)
        puts "Range of the Day: #{quote_hash[:days_range]}" if quote_hash.fetch(:days_range, nil)
        puts "Previous Close Value: #{quote_hash[:previous_close_value=]}" if quote_hash.fetch(:previous_close_value=, nil)
        puts "Timestamp: #{quote_hash[:timestamp]}"
        puts '--'
      end
    end
  end
end
