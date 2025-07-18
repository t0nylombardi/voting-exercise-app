# frozen_string_literal: true

# == Schema Information
#
# Table name: candidates
#
#  id          :string           not null, primary key
#  name        :string           not null
#  votes_count :integer          default(0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_candidates_on_name  (name)
#
FactoryBot.define do
  factory :candidate do
    id { SecureRandom.uuid }
    name { Faker::Name.name }
    votes_count { Faker::Number.non_zero_digit }
  end
end
