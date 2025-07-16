# frozen_string_literal: true

FactoryBot.define do
  factory :candidate do
    id { SecureRandom.uuid }
    name { Faker::Name.name }
    vote_count { Faker::Number.non_zero_digit }
  end
end
