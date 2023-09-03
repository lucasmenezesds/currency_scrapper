# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
module GFinanceFixtures
  def self.usd_jpy_html_txt
    '<div jscontroller="NdbN0c" jsaction="oFr1Ad:uxt3if;" jsname="AS5Pxb" data-mid="/g/11bvvznqzd" data-entity-type="3"
     data-source="USD" data-target="JPY" data-last-price="146.2165" data-last-normal-market-timestamp="1693775876"
     data-tz-offset="0">
    <div class="rPF6Lc" jsname="OYCkv">
        <div class="ln0Gqe">
            <div jsname="LXPcOd" class="">
                <div class="AHmHk"><span class=""><div jsname="ip75Cb" class="kf1m0"><div
                        class="YMlKec fxKbKc">146.2165</div></div></span></div>
            </div>
            <div jsname="CGyduf" class="">
                <div class="enJeMd"><span jsname="Fe7oBc" class="NydbP nZQ6l tnNmPe" data-disable-percent-toggle="true"
                                          data-multiplier-for-price-change="1" aria-label="Up by 0.0085%"><div
                        jsname="m6NnIb" class="zWwE1"><div class="JwB6zf" style="font-size: 16px;"><span class="V53LMb"
                                                                                                         aria-hidden="true"><svg
                        focusable="false" width="16" height="16" viewBox="0 0 24 24" class=" NMm5M"><path
                        d="M4 12l1.41 1.41L11 7.83V20h2V7.83l5.58 5.59L20 12l-8-8-8 8z"></path></svg></span>0.0085%</div></div></span><span
                        class="P2Luy Ez2Ioe ZYVHBb">+0.0125 Today</span></div>
            </div>
        </div>
    </div>
    <div class="ygUjEc" jsname="Vebqub">Sep 3, 9:17:56 PM UTC · <a><span class="koPoYd">Disclaimer</span></a>
    </div>
</div>'
  end

  def self.html_with_different_xpath
    '<div class="rPF6Lc" jsname="OYCkv">
        <div class="ln0Gqe">
            <div jsname="LXPcOd" class="">
                <div class="AHmHk"><span class=""><div jsname="ip75Cb" class="kf1m0"><div
                        class="AAABBBCCC fxKbKc">146.2165</div></div></span></div>
            </div>
        </div>
    </div>
    <div class="ygUjEc" jsname="WHATEVER">Sep 3, 9:17:56 PM UTC · <a><span class="koPoYd">Disclaimer</span></a>
    </div>'
  end
end

# rubocop:enable Metrics/MethodLength
