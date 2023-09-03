# frozen_string_literal: true

require_relative '../../fixtures/gfinance_fixtures'

describe CurrencyScrapper::GoogleFinance do
  subject(:google_finance) { described_class.new(base_currency: 'USD', target_currency: 'JPY') }

  let(:httparty_response_double) { instance_double(HTTParty::Response) }

  describe '#initialize' do
    it 'creates an object with the expected attributes' do
      result = described_class.new(base_currency: 'USD', target_currency: 'JPY')

      expect(result.instance_variable_get(:@base_url)).to eq('https://www.google.com/finance/quote/')
      expect(result.instance_variable_get(:@base_currency)).to eq('USD')
      expect(result.instance_variable_get(:@target_currency)).to eq('JPY')
    end

    it 'has the expected constant values for the XPATH parse' do
      expect(CurrencyScrapper::GoogleFinance::XPATH_CURRENCY_CLASS).to eq('YMlKec fxKbKc')
      expect(CurrencyScrapper::GoogleFinance::XPATH_TIMESTAMP_IDENTIFIER).to eq('Vebqub')
    end
  end

  describe '#quote_currency' do
    # rubocop: disable RSpec/SubjectStub
    it 'calls #retrieve_currency_data' do
      expect(described_class).to receive(:new).and_return(google_finance).once
      expect(google_finance).to receive(:retrieve_currency_data).once

      described_class.quote_currency('USD', 'JPY')
    end
    # rubocop: enable RSpec/SubjectStub
  end

  describe '#currency_path' do
    it 'returns the expected concatenated string' do
      result = google_finance.send(:currency_path)

      expect(result).to eq('USD-JPY')
    end
  end

  describe '#safely_parse' do
    let(:data_not_found_message) { 'The request worked but no data was parsed. Please contact the developers to update the gem.' }

    context 'when the input data is correct' do
      it 'returns a hash with the expected values' do
        converted_html = Nokogiri::HTML4(GFinanceFixtures.usd_jpy_html_txt)
        expected_result = { sell_value: '146.2165', timestamp: 'Sep 3, 9:17:56 PM UTC' }

        result = google_finance.send(:safely_parse, converted_html)

        expect(result).to eq(expected_result)
      end
    end

    context 'when the html received has changed the classes used on the xpath' do
      it 'returns the hash with empty sell_value and nil timestamp' do
        converted_html = Nokogiri::HTML4(GFinanceFixtures.html_with_different_xpath)
        expected_result = { sell_value: '', timestamp: nil }

        result = google_finance.send(:safely_parse, converted_html)

        expect(result).to eq(expected_result)
      end
    end

    context 'when theres a one of the currencies code is invalid' do
      it 'raises CurrencyNotFound error' do
        expected_message = 'One of the currencies used is not available, please try a different one.'
        expect do
          text = "<html><body>We couldn't find any match for your search</body></html>"
          converted_html = Nokogiri::HTML4(text)

          google_finance.send(:safely_parse, converted_html)
        end.to raise_error(CurrencyScrapper::CurrencyNotFound, expected_message)
      end
    end

    context 'when the input is nil' do
      it 'raises DataNotFound error' do
        expect do
          google_finance.send(:safely_parse, nil)
        end.to raise_error(CurrencyScrapper::DataNotFound, data_not_found_message)
      end
    end

    context 'when the converted_html is with the empty text' do
      it 'raises DataNotFound error' do
        expect do
          converted_html = Nokogiri::HTML4('')
          google_finance.send(:safely_parse, converted_html)
        end.to raise_error(CurrencyScrapper::DataNotFound, data_not_found_message)
      end
    end
  end

  # rubocop: disable RSpec/SubjectStub
  describe '#retrieve_currency_data' do
    context 'when the input data is with real and valid data' do
      it 'returns the expected values within the hash' do
        parsed_data = { sell_value: 145.10, timestamp: 'Sun Oct 25 10:30:00 2020' }
        expected_data = parsed_data.merge({ base_currency: 'USD', target_currency: 'JPY' })

        expect(google_finance).to receive(:request_data).and_return(httparty_response_double).once
        expect(httparty_response_double).to receive(:body).and_return('<html></html>').once
        expect(google_finance).to receive(:convert_html).with('<html></html>').once
        expect(google_finance).to receive(:safely_parse).and_return(parsed_data)
        expect(google_finance).to receive(:quote_data).with(base_currency: 'USD', target_currency: 'JPY', **parsed_data)
                                                      .and_return(expected_data).once

        result = google_finance.send(:retrieve_currency_data)

        expect(result).to eq(expected_data)
      end
    end

    context 'when the input is with empty and nil values' do
      it 'returns the expected values within the hash' do
        parsed_data = { sell_value: 0.0, timestamp: nil }
        expected_data = parsed_data.merge({ base_currency: 'USD', target_currency: 'JPY' })

        expect(google_finance).to receive(:request_data).and_return(httparty_response_double).once
        expect(httparty_response_double).to receive(:body).and_return('<html></html>').once
        expect(google_finance).to receive(:convert_html).with('<html></html>').once
        expect(google_finance).to receive(:safely_parse).and_return(parsed_data)
        expect(google_finance).to receive(:quote_data).with(base_currency: 'USD', target_currency: 'JPY', **parsed_data)
                                                      .and_return(expected_data).once

        result = google_finance.send(:retrieve_currency_data)

        expect(result).to eq(expected_data)
      end
    end
  end
  # rubocop: enable RSpec/SubjectStub
end
