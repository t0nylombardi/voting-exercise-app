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
class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :candidate, counter_cache: true

  validate :user_has_not_already_voted

  before_create -> { self.id ||= SecureRandom.uuid }

  private

  def user_has_not_already_voted
    if user&.participation&.has_voted?
      errors.add(:user, "has already voted")
    end
  end
end
