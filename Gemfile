source "https://rubygems.org"

ruby "3.1.2"

# Rails framework
gem "rails", "~> 7.0.3"

# Database
gem "sqlite3", "~> 1.4"
gem "redis", ">= 4.0.1"

# Web server
gem "puma", ">= 5.0"

# Asset pipeline / JavaScript
gem "sprockets-rails"
gem "shakapacker", "= 8.1"
gem "react-rails", "= 3.2"

# JSON builder
gem "jbuilder"

# Miscellaneous
gem "tzinfo-data", platforms: %i[windows jruby]
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[mri windows]
  gem "factory_bot_rails"
  gem "ruby-lsp-rails-factory-bot"
  gem "faker"
  gem "irb"
  gem "pry"
  gem "pry-byebug"
  gem "rspec"
  gem "rspec-rails"
  gem "shoulda-matchers"
end

group :development do
  gem "annotaterb"
  gem "web-console"
  gem "rubocop-rake"
  gem "rubocop-rspec"
  gem "rubocop-thread_safety"
  gem "rubocop-rails-omakase", require: false
  gem "ruby_audit"
  gem "ruby-lsp-rspec"
  gem "standard", ">= 1.50.0"
  gem "standard-rails"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
