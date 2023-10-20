# frozen_string_literal: true

require_relative '../../fixtures/investing_fixtures'

describe CurrencyScrapper::InvestingDotCom do
  subject(:investing_dot_com) { described_class.new(base_currency: 'usd', target_currency: 'jpy') }

  let(:httparty_response_double) { instance_double(HTTParty::Response) }

  describe '#initialize' do
    it 'creates an object with the expected attributes' do
      result = described_class.new(base_currency: 'usd', target_currency: 'jpy')

      expect(result.instance_variable_get(:@base_url)).to eq('https://www.investing.com/currencies/')
      expect(result.instance_variable_get(:@base_currency)).to eq('usd')
      expect(result.instance_variable_get(:@target_currency)).to eq('jpy')
    end

    it 'creates an object with sanitized currencies' do
      result = described_class.new(base_currency: '%$', target_currency: '%$#$#@123jpy')

      expect(result.instance_variable_get(:@base_currency)).to eq('')
      expect(result.instance_variable_get(:@target_currency)).to eq('jpy')
    end

    it 'has the expected constant values for the XPATH parse' do
      expect(CurrencyScrapper::InvestingDotCom::XPATH_BID_ASK_IDENTIFIER).to eq('bid-value')
      expect(CurrencyScrapper::InvestingDotCom::XPATH_CURRENCY_IDENTIFIER).to eq('instrument-price-last')
      expect(CurrencyScrapper::InvestingDotCom::XPATH_PREV_CLOSE_IDENTIFIER).to eq('prev-close-value')
      expect(CurrencyScrapper::InvestingDotCom::XPATH_DAYS_RANGE_IDENTIFIER).to eq('range-value')
      expect(CurrencyScrapper::InvestingDotCom::XPATH_TIMESTAMP_CLASS).to eq('instrument-metadata_time__fopxP')
    end
  end

  describe '#quote_currency' do
    # rubocop: disable RSpec/SubjectStub
    it 'calls #retrieve_currency_data' do
      expect(described_class).to receive(:new).and_return(investing_dot_com).once
      expect(investing_dot_com).to receive(:retrieve_currency_data).once

      described_class.quote_currency('usd', 'jpy')
    end
  end

  describe '#quote' do
    it 'behaves as an alias of #quote_currency' do
      expect(described_class).to receive(:new).and_return(investing_dot_com).once
      expect(investing_dot_com).to receive(:retrieve_currency_data).once

      described_class.quote('usd', 'jpy')
    end
    # rubocop: enable RSpec/SubjectStub
  end

  describe '#currency_path' do
    it 'returns the expected concatenated string' do
      result = investing_dot_com.send(:currency_path)

      expect(result).to eq('usd-jpy')
    end
  end

  describe '#safely_parse' do
    let(:data_not_found_message) { 'The request worked but no data was parsed. Please contact the developers to update the gem.' }

    context 'when the input data is correct' do
      it 'returns a hash with the expected values' do
        converted_html = Nokogiri::HTML4(InvestingFixtures.usd_jpy_html_txt)
        expected_result = { bid_ask: '149.29/149.32', days_range: '148.37 - 149.54', prev_close: '148.5',
                            sell_value: '149.30', timestamp: '2023-10-06T20:59:53.000Z' }

        result = investing_dot_com.send(:safely_parse, converted_html)

        expect(result).to eq(expected_result)
      end
    end

    context 'when the html received has changed the classes used on the xpath' do
      it 'returns the hash with empty sell_value and nil timestamp' do
        converted_html = Nokogiri::HTML4(InvestingFixtures.html_with_different_xpath)
        expected_result = { bid_ask: '', days_range: '', prev_close: '', sell_value: '', timestamp: nil }

        result = investing_dot_com.send(:safely_parse, converted_html)

        expect(result).to eq(expected_result)
      end
    end

    context 'when theres a one of the currencies code is invalid' do
      it 'raises CurrencyNotFound error' do
        expected_message = 'One of the currencies used is not available, please try a different one.'
        expect do
          text = "<html><body>Seems like the page you were looking for isn't here.</body></html>"
          converted_html = Nokogiri::HTML4(text)

          investing_dot_com.send(:safely_parse, converted_html)
        end.to raise_error(CurrencyScrapper::CurrencyNotFound, expected_message)
      end
    end

    context 'when the input is nil' do
      it 'raises DataNotFound error' do
        expect do
          investing_dot_com.send(:safely_parse, nil)
        end.to raise_error(CurrencyScrapper::DataNotFound, data_not_found_message)
      end
    end

    context 'when the converted_html is with the empty text' do
      it 'raises DataNotFound error' do
        expect do
          converted_html = Nokogiri::HTML4('')
          investing_dot_com.send(:safely_parse, converted_html)
        end.to raise_error(CurrencyScrapper::DataNotFound, data_not_found_message)
      end
    end
  end

  # rubocop: disable RSpec/SubjectStub
  describe '#retrieve_currency_data' do
    context 'when the input data is with real and valid data' do
      it 'returns the expected values within the hash' do
        parsed_data = { sell_value: 145.10, bid_ask: '144.99/145.10', prev_close: 145.20,
                        days_range: '144.99 - 145.99', timestamp: 'Sun Oct 25 10:30:00 2020' }

        expected_data = { base_currency: 'usd', buy_value: 144.99, days_range: '144.99 - 145.99',
                          previous_close_value: 145.2, sell_value: 145.1, target_currency: 'jpy',
                          timestamp: 'Oct 25,10:30:00 AM UTC' }

        expect(investing_dot_com).to receive(:request_data).and_return(httparty_response_double).once
        expect(httparty_response_double).to receive(:body).and_return('<html></html>').once
        expect(investing_dot_com).to receive(:convert_html).with('<html></html>').once
        expect(investing_dot_com).to receive(:safely_parse).and_return(parsed_data)

        result = investing_dot_com.send(:retrieve_currency_data)

        expect(result).to eq(expected_data)
      end
    end

    context 'when the input is with empty and nil values' do
      it 'returns the expected values within the hash' do
        parsed_data = { sell_value: 0.0, buy_value: 0.0, days_range: nil, previous_close_value: 0.0, timestamp: nil }
        expected_data = parsed_data.merge({ base_currency: 'usd', target_currency: 'jpy' })

        expect(investing_dot_com).to receive(:request_data).and_return(httparty_response_double).once
        expect(httparty_response_double).to receive(:body).and_return('<html></html>').once
        expect(investing_dot_com).to receive(:convert_html).with('<html></html>').once
        expect(investing_dot_com).to receive(:safely_parse).and_return(parsed_data)
        expect(investing_dot_com).to receive(:quote_data).with(base_currency: 'usd', target_currency: 'jpy', **parsed_data)
                                                         .and_return(expected_data).once

        result = investing_dot_com.send(:retrieve_currency_data)

        expect(result).to eq(expected_data)
      end
    end
  end

  describe '#request_data' do
    let(:httparty_response_double) { instance_double(HTTParty::Response) }

    it 'sends a request via httparty successfully' do
      expect(HTTParty).to receive(:get).and_return(httparty_response_double)
      expect(investing_dot_com).to receive(:currency_path).and_return('usd-jpy')
      expect(httparty_response_double).to receive(:code).and_return(200).twice
      expect(httparty_response_double).to receive_message_chain(:response, :body).and_return('some response')

      result = investing_dot_com.send(:request_data)

      expect(result).to eq(httparty_response_double)
    end

    it 'requests to a sanitized URL' do
      expect(investing_dot_com).to receive(:currency_path).and_return('%$-#@3921jpy')
      expect(HTTParty).to receive(:get).with('https://www.investing.com/currencies/%25$-%23@3921jpy').and_return(httparty_response_double)
      allow(httparty_response_double).to receive(:code).and_return(200)
      allow(httparty_response_double).to receive_message_chain(:response, :body).and_return('some response')

      investing_dot_com.send(:request_data)
    end

    it 'sends a request via httparty that returns 404 and raise an exception' do
      expected_message = 'One of the currencies used is not available, please try a different one.'
      expect do
        allow(HTTParty).to receive(:get).and_return(httparty_response_double)
        allow(investing_dot_com).to receive(:currency_path).and_return('usd-jpy')
        expect(httparty_response_double).to receive(:code).and_return(404).once

        result = investing_dot_com.send(:request_data)

        expect(result).to eq(httparty_response_double)
      end.to raise_error(CurrencyScrapper::CurrencyNotFound, expected_message)
    end

    it 'sends a request via httparty that returns 200 but with an empty body response' do
      expect do
        allow(HTTParty).to receive(:get).and_return(httparty_response_double)
        allow(investing_dot_com).to receive(:currency_path).and_return('usd-jpy')
        expect(httparty_response_double).to receive(:code).and_return(200).twice
        expect(httparty_response_double).to receive_message_chain(:response, :body).and_return('')

        result = investing_dot_com.send(:request_data)

        expect(result).to eq(httparty_response_double)
      end.to raise_error(CurrencyScrapper::UnsuccessfulRequest,
                         'The request failed, try again later. If the problem persists check if your IP was not blocked.')
    end
  end

  # rubocop: enable RSpec/SubjectStub
end
