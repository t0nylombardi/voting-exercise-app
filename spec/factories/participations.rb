# frozen_string_literal: true

FactoryBot.define do
  factory :participation do
    id { SecureRandom.uuid }
    user
    has_voted { false }
    has_written_in { false }
    device_type { 'desktop' }
  end
end
