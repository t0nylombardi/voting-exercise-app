# frozen_string_literal: true

RSpec.configure do |config|
  Faker::Config.random = Random.new(config.seed)
end
