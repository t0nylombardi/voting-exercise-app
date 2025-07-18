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
class Candidate < ApplicationRecord
  validates :name, presence: true

  before_create -> { self.id ||= SecureRandom.uuid }

  has_many :votes, dependent: :destroy
  has_many :users, through: :votes
end
