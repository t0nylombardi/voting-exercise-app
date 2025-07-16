# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    zip_code { Faker::Address.zip_code }
  end
end
