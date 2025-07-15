# frozen_string_literal: true

class User < ApplicationRecord
  has_one :participation, dependent: :destroy
  has_many :votes
  has_many :candidates, through: :votes

  validates :email, presence: true, uniqueness: true
  validates :zip_code, presence: true

  before_create -> { self.id ||= SecureRandom.uuid }
end
