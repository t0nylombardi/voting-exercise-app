# frozen_string_literal: true

class Candidate < ApplicationRecord
  validates :name, presence: true

  before_create -> { self.id ||= SecureRandom.uuid }

  has_many :votes, dependent: :destroy
  has_many :users, through: :votes
end
