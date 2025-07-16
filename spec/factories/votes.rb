# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    id { SecureRandom.uuid }
    user_id { SecureRandom.uuid }
    candidate_id { SecureRandom.uuid }
  end
end
