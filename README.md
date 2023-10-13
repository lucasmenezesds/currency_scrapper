# CurrencyScrapper

This gem is a wrapper of a simple scrapper to make it easy to check the currency quote.
It's possible to use it in a project or the CLI option.

## Disclaimer

Due the nature of this gem, it's provided as-is, without any warranties or guarantees of any kind. The author(s) of this
gem are not responsible for any consequences, including but not limited to, damages, errors, or misuse resulting from
the use of this gem.

Users of this gem are expected to understand its functionality and use it responsibly.

By using this gem, you acknowledge and accept that the author(s) shall not be held liable for any issues or damages
arising from its use.

It's not recommended using the gem on a production environment since it depends on third-parties. Additionally the
gem was purely developed as a hobby project.

## Installation

### Using Bundler

```ruby
gem 'currency_scrapper', git: 'https://github.com/lucasmenezesds/currency_scrapper'
```

### CLI

Since the gem is not published you'll need to clone the repository.

After cloning the repository, navigate to inside the folder and run

```bash
$ gem build currency_scrapper.gemspec
```

```bash
$ gem install currency_scrapper-0.3.0.gem

# OR

$ gem install currency_scrapper-X.X.X.gem
```

Where `X.X.X` is the version of the gem generated after you run the build command.

## Usage

**NOTE:** Please make sure you're using the correct initials(ticker) for the currency you would like to check it's
values.

**NOTE 2:** This gem just gets the values from the website in question, if the currency values are wrong, please check
the website before opening a PR.

### In a project / IRB, etc~

**For Google Finance**

```ruby
require 'currency_scrapper'

usd_jpy = CurrencyScrapper::GoogleFinance.quote_currency('USD', 'JPY')
puts usd_jpy
# => { :sell_value=>146.1795, :base_currency=>"USD", :target_currency=>"JPY", :timestamp=>"Sep 3, 10:38:56 PM UTC" }
```

**For Investing Dot Com**

```ruby
require 'currency_scrapper'

usd_jpy = CurrencyScrapper::InvestingDotCom.quote_currency('USD', 'JPY')
puts usd_jpy
# => {:sell_value=>149.3, :base_currency=>"usd", :target_currency=>"jpy", :timestamp=>"Oct  6, 8:59:53 PM UTC", :buy_value=>149.29, :previous_close_value=>148.5, :days_range=>"148.37 - 149.54"
```

### CLI

**For Google Finance**

```bash
$ currency_scrapper usd-jpy

# OR

$ currency_scrapper usd-jpy -gf
```

**For Investing Dot Com**

```bash
$ currency_scrapper usd-jpy -idc
```

### Currency Tickers Examples

Some examples of currency tickers are:

```
USD - United States Dollar
EUR - Euro
GBP - British Pound Sterling
BRL - Brazilian Real
JPY - Japanese Yen
AUD - Australian Dollar
CAD - Canadian Dollar
CHF - Swiss Franc
CNY - Chinese Yuan
INR - Indian Rupee
SGD - Singapore Dollar
MXN - Mexican Peso
NZD - New Zealand Dollar
ZAR - South African Rand
AED - United Arab Emirates Dirham
HKD - Hong Kong Dollar
SEK - Swedish Krona
NOK - Norwegian Krone
DKK - Danish Krone
KRW - South Korean Won
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
