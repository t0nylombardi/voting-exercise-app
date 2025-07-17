# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  # Associations
  has_one :participation, dependent: :destroy
  has_many :votes
  has_many :candidates, through: :votes

  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :zip_code, presence: true

  before_create -> { self.id ||= SecureRandom.uuid }
end
