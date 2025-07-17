# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  # Associations
  has_one :participation, dependent: :destroy
  has_many :votes
  belongs_to :write_in, class_name: "Candidate", optional: true
  has_many :candidates, through: :votes

  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :zip_code, presence: true

  before_create -> { self.id ||= SecureRandom.uuid }

  # Checks if the user has already voted
  #
  # @return [Boolean] Whether the user has voted or not.
  # @note A user is considered to have voted if they have any votes associated with them.
  #
  # @return [Boolean] Whether the user has voted or not.
  def voted?
    votes.loaded? ? votes.any? : votes.exists?
  end
end
