# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
module InvestingFixtures
  def self.usd_jpy_html_txt
    '<div data-test="instrument-header-details">
    <div class="instrument-price_instrument-price__2w9MW flex items-end flex-wrap font-bold">
        <span class="text-2xl" data-test="instrument-price-last">149.30</span>
    </div>
    <div class="instrument-metadata_instrument-metadata__zsP5Y mt-4 flex items-end flex-wrap">
        <div class="instrument-metadata_time__fopxP">
            <time class="instrument-metadata_text__Y52j_ font-bold" datetime="2023-10-06T20:59:53.000Z">06/10</time>
            <span class="instrument-metadata_text__Y52j_">-</span><span
                class="instrument-metadata_text__Y52j_">Closed</span>.
        </div>
    </div>
    <ul class="trading-hours_trading-hours__epZb0 mt-3">
        <li class="list_list__item__dwS6E trading-hours_trading-hours-item__oML4v">
            <div class="trading-hours_title__Wkmst" data-test="prev-close-title">Prev. Close<!-- --> :</div>
            <div class="trading-hours_value__1aTHe" data-test="prev-close-value">148.5</div>
        </li>
        <li class="list_list__item__dwS6E trading-hours_trading-hours-item__oML4v">
            <div class="trading-hours_title__Wkmst" data-test="bid-title">Bid/Ask<!-- --> :</div>
            <div class="trading-hours_value__1aTHe" data-test="bid-value"><span class="">149.29</span><span
                    class="px-1">/</span><span class="">149.32</span></div>
        </li>
        <li class="list_list__item__dwS6E trading-hours_trading-hours-item__oML4v">
            <div class="trading-hours_title__Wkmst" data-test="range-title">Days Range<!-- --> :</div>
            <div class="trading-hours_value__1aTHe" data-test="range-value">148.37 - 149.54</div>
        </li>
    </ul>
</div>'
  end

  def self.html_with_different_xpath
    '<div data-test="instrument-header-details">
    <div class="instrument-price_instrument-price__2w9MW flex items-end flex-wrap font-bold">
        <span class="text-2xl" data-test="SELL-PRICE-HERE">149.30</span>
    </div>
    <div class="instrument-metadata_instrument-metadata__zsP5Y mt-4 flex items-end flex-wrap">
        <div class="instrument-TIME-HERE">
            <time class="instrument-metadata_text__Y52j_ font-bold" datetime="2023-10-06T20:59:53.000Z">06/10</time>
            <span class="instrument-metadata_text__Y52j_">-</span><span
                class="instrument-metadata_text__Y52j_">Closed</span>.
        </div>
    </div>
    <ul class="trading-hours_trading-hours__epZb0 mt-3">
        <li class="list_list__item__dwS6E trading-hours_trading-hours-item__oML4v">
            <div class="trading-hours_title__Wkmst" data-test="prev-close-title">Prev. Close<!-- --> :</div>
            <div class="trading-hours_value__1aTHe" data-test="prev-CLOSED-VAL">148.5</div>
        </li>
        <li class="list_list__item__dwS6E trading-hours_trading-hours-item__oML4v">
            <div class="trading-hours_title__Wkmst" data-test="bid-title">Bid/Ask<!-- --> :</div>
            <div class="trading-hours_value__1aTHe" data-test="bid-VALUE-HERE"><span class="">149.29</span><span
                    class="px-1">/</span><span class="">149.32</span></div>
        </li>
        <li class="list_list__item__dwS6E trading-hours_trading-hours-item__oML4v">
            <div class="trading-hours_title__Wkmst" data-test="range-title">Days Range<!-- --> :</div>
            <div class="trading-hours_value__1aTHe" data-test="range-VALUE-HERE">148.37 - 149.54</div>
        </li>
    </ul>
</div>'
  end
end

# rubocop:enable Metrics/MethodLength
