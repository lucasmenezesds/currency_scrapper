# frozen_string_literal: true

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

  describe '#currency_path' do
    it 'returns the expected concatenated string' do
      result = google_finance.send(:currency_path)

      expect(result).to eq('USD-JPY')
    end
  end

  # rubocop: disable RSpec/SubjectStub
  describe '#retrieve_currency_data' do
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
  # rubocop: enable RSpec/SubjectStub
end
