# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :string           not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  zip_code        :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  write_in_id     :string
#
# Indexes
#
#  index_users_on_email        (email) UNIQUE
#  index_users_on_write_in_id  (write_in_id)
#
# Foreign Keys
#
#  write_in_id  (write_in_id => candidates.id)
#
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
