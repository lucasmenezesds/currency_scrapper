# frozen_string_literal: true

context 'when testing E2E scenarios' do
  describe CurrencyScrapper::GoogleFinance, e2e: true, type: :e2e do
    subject(:google_finance) { described_class.new(base_currency: 'USD', target_currency: 'JPY') }

    # Yes, its crazy, but since E2E tests are just for checking if the scrappers are working
    # I rather have a little sleep just because.
    before do
      sleep 0.1
    end

    describe '#retrieve_currency_data' do
      context 'when successfully fetching an existing currency' do
        it 'creates an object with the expected attributes' do
          result = google_finance.retrieve_currency_data
          sell_value = result[:sell_value]
          request_timestamp = Time.parse(result[:timestamp]).strftime('%b%e,%l %p UTC') # Original Timestamp: '%b%e,%l:%M:%S %p UTC'
          timestamp_now = Time.parse(result[:timestamp]).strftime('%b%e,%l %p UTC')

          expect(sell_value).to be_an_instance_of(Float)
          expect(request_timestamp).to eq(timestamp_now)
        end
      end

      context 'when fetching an invalid currency' do
        it 'creates an object with the expected attributes' do
          expected_message = 'One of the currencies used is not available, please try a different one.'
          expect do
            finance = described_class.new(base_currency: 'USD2', target_currency: 'JPYz')
            finance.retrieve_currency_data
          end.to raise_error(CurrencyScrapper::CurrencyNotFound, expected_message)
        end
      end
    end
  end
end
