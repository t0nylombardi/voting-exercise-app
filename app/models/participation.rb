# frozen_string_literal: true

class Participation < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true

  before_create -> { self.id ||= SecureRandom.uuid }
end
