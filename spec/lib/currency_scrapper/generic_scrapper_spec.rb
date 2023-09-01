# frozen_string_literal: true

describe CurrencyScrapper::GenericScrapper do
  subject(:generic_scrapper) { described_class.new(base_url: 'localhost:3000') }

  describe '#initialize' do
    it 'creates an object with base_url attribute' do
      result = described_class.new(base_url: 'localhost:8000')

      expect(result.instance_variable_get(:@base_url)).to eq('localhost:8000')
    end
  end

  # rubocop: disable RSpec/SubjectStub
  describe '#html_data' do
    let(:httparty_response_double) { instance_double(HTTParty::Response) }

    it 'sends a request via httparty successfully' do
      expect(HTTParty).to receive(:get).and_return(httparty_response_double)
      expect(generic_scrapper).to receive(:currency_path).and_return('USD-JPY')
      expect(httparty_response_double).to receive(:code).and_return(200)
      expect(httparty_response_double).to receive_message_chain(:response, :body).and_return('some response')

      result = generic_scrapper.send(:request_data)

      expect(result).to eq(httparty_response_double)
    end

    it 'sends a request via httparty that DOESNT return 200' do
      expect do
        allow(HTTParty).to receive(:get).and_return(httparty_response_double)
        allow(generic_scrapper).to receive(:currency_path).and_return('USD-JPY')
        expect(httparty_response_double).to receive(:code).and_return(404)

        result = generic_scrapper.send(:request_data)

        expect(result).to eq(httparty_response_double)
      end.to raise_error(CurrencyScrapper::UnsuccessfulRequest,
                         'The request failed, try again later. If the problem persists check if your IP was not blocked.')
    end

    it 'sends a request via httparty that returns 200 but with an empty body response' do
      expect do
        allow(HTTParty).to receive(:get).and_return(httparty_response_double)
        allow(generic_scrapper).to receive(:currency_path).and_return('USD-JPY')
        expect(httparty_response_double).to receive(:code).and_return(200)
        expect(httparty_response_double).to receive_message_chain(:response, :body).and_return('')

        result = generic_scrapper.send(:request_data)

        expect(result).to eq(httparty_response_double)
      end.to raise_error(CurrencyScrapper::UnsuccessfulRequest,
                         'The request failed, try again later. If the problem persists check if your IP was not blocked.')
    end
  end

  # rubocop: enable RSpec/SubjectStub

  describe '#convert_html' do
    it 'returns a Nokogiri object' do
      result = generic_scrapper.send(:convert_html, '<html><head></head></html>')

      expect(result.class).to eq(Nokogiri::HTML4::Document)
    end
  end

  describe '#quote_data' do
    it 'creates a hash with the required parameters only' do
      expected_values = { sell_value: 145.20,
                          base_currency: 'USD',
                          target_currency: 'JPY',
                          timestamp: 'Sun Oct 25 10:30:00 2020' }

      result = generic_scrapper.send(:quote_data, **expected_values)

      expect(result).to eq(expected_values)
    end

    it 'creates a hash with ALL the parameters' do
      expected_values = { sell_value: 145.20,
                          base_currency: 'USD',
                          target_currency: 'JPY',
                          buy_value: 145.25,
                          days_range: '145.10 - 145.30',
                          previous_close_value: 145.40,
                          timestamp: 'Sun Oct 25 10:30:00 2020' }

      result = generic_scrapper.send(:quote_data, **expected_values)

      expect(result).to eq(expected_values)
    end
  end

  describe '#currency_path' do
    it 'raises error asking for implementing method on the subclass' do
      expect do
        generic_scrapper.send(:currency_path)
      end.to raise_error('currency_path method must be implemented in subclass')
    end
  end

  describe '#retrieve_currency_data' do
    it 'raises error asking for implementing method on the subclass' do
      expect do
        generic_scrapper.send(:retrieve_currency_data)
      end.to raise_error('retrieve_currency_data method must be implemented in subclass')
    end
  end
end
