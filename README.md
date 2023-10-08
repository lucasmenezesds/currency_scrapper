# CurrencyScrapper

## Disclaimer

Due the nature of this gem, it's provided as-is, without any warranties or guarantees of any kind. The author(s) of this
gem are not responsible for any consequences, including but not limited to, damages, errors, or misuse resulting from
the use of this gem.

Users of this gem are expected to understand its functionality and use it responsibly.

By using this gem, you acknowledge and accept that the author(s) shall not be held liable for any issues or damages
arising from its use.

It's not recommended using the gem on a production environment since it depends on third-parties. Additionally the
gem was purely developed as a hobby project.

## Usage

**NOTE:** Please make sure you're using the correct initials for the currency you would like to check it's values.

**For Google Finance**

```ruby
usd_jpy = CurrencyScrapper::GoogleFinance.quote_currency('USD', 'JPY')
puts usd_jpy
# => { :sell_value=>146.1795, :base_currency=>"USD", :target_currency=>"JPY", :timestamp=>"Sep 3, 10:38:56 PM UTC" }
```

**For Investing Dot Com**

```ruby
usd_jpy = CurrencyScrapper::InvestingDotCom.quote_currency('USD', 'JPY')
puts usd_jpy
# => {:sell_value=>149.3, :base_currency=>"usd", :target_currency=>"jpy", :timestamp=>"Oct  6, 8:59:53 PM UTC", :buy_value=>149.29, :previous_close_value=>148.5, :days_range=>"148.37 - 149.54"
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lucasmenezesds/currency_scrapper. This project
is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to
the [code of conduct](https://github.com/lucasmenezesds/currency_scrapper/blob/main/CODE_OF_CONDUCT.md).

### Running tests

**Unit Tests**

```
bundle exec rspec
```

**End-to-End Tests**

```
bundle exec rspec --tag e2e:true
```

## License

The gem is available as open sour ce under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CurrencyScrapper project's codebases, issue trackers, chat rooms and mailing lists is
expected to follow
the [code of conduct](https://github.com/lucasmenezesds/currency_scrapper/blob/main/CODE_OF_CONDUCT.md).
