# frozen_string_literal: true

# == Schema Information
#
# Table name: votes
#
#  id           :string           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  candidate_id :string           not null
#  user_id      :string           not null
#
# Indexes
#
#  index_votes_on_user_id_and_candidate_id  (user_id,candidate_id) UNIQUE
#
# Foreign Keys
#
#  candidate_id  (candidate_id => candidates.id)
#  user_id       (user_id => users.id)
#
FactoryBot.define do
  factory :vote do
    id { SecureRandom.uuid }
    user_id { SecureRandom.uuid }
    candidate_id { SecureRandom.uuid }
  end
end
