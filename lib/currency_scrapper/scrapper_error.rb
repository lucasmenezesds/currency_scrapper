# frozen_string_literal: true

module CurrencyScrapper
  class CurrencyScrapperError < StandardError; end

  # Invalid Currency Error
  class CurrencyNotFound < StandardError
    def initialize(msg = 'One of the currencies used is not available, please try a different one.')
      super
    end
  end

  # Data was not able to be parsed (probably due layout update on the scrapped sites)
  class DataNotFound < StandardError
    def initialize(msg = 'The request worked but no data was parsed. Please contact the developers to update the gem.')
      super
    end
  end

  # Unsuccessful request
  class UnsuccessfulRequest < StandardError
    def initialize(msg = 'The request failed, try again later. If the problem persists check if your IP was not blocked.')
      super
    end
  end
end
