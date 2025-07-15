# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :candidate

  validates :candidate_id, presence: true
  validate :user_has_not_already_voted

  before_create -> { self.id ||= SecureRandom.uuid }

  private

  def user_has_not_already_voted
    if user&.participation&.has_voted?
      errors.add(:user, "has already voted")
    end
  end
end
