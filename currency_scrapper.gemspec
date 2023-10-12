# frozen_string_literal: true

require_relative 'lib/currency_scrapper/version'

Gem::Specification.new do |spec|
  spec.name = 'currency_scrapper'
  spec.version = CurrencyScrapper::VERSION
  spec.authors = ['Lucas M']

  spec.summary = 'Currency Scrapper is a simple gem to get the currency rates from the web.'
  spec.description = 'Currency Scrapper gets the currency rates from the web instead of getting it from some API.'
  spec.homepage = 'https://github.com/lucasmenezesds/currency_scrapper'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2.2'

  spec.metadata['homepage_uri'] = spec.homepage

  spec.metadata['disclaimer'] = 'This gem is provided as-is, without any warranties or guarantees. By using this gem,
you acknowledge and accept that the author(s) shall not be held liable for any issues or damages arising from its use.'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = 'currency_scrapper'
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'httparty', '~> 0.21.0'
  spec.add_dependency 'nokogiri', '~> 1.15', '>= 1.15.4'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
