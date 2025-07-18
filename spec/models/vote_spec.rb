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
require "rails_helper"

RSpec.describe Vote, type: :model do
  subject(:vote) { build(:vote, user: user, candidate: candidate) }

  let(:user) { create(:user) }
  let(:candidate) { create(:candidate) }

  describe "valid factory" do
    it "is valid with valid attributes" do
      expect(vote).to be_valid
    end
  end

  describe "associations" do
    it "belongs to user" do
      expect(vote).to belong_to(:user)
    end

    it "belongs to candidate" do
      expect(vote).to belong_to(:candidate)
    end
  end

  describe "callbacks" do
    let(:persisted_vote) { create(:vote, user: user, candidate: candidate) }

    it "assigns UUID on create" do
      expect(persisted_vote.id).to be_present
    end

    it "assigns a valid UUID format" do
      expect(persisted_vote.id).to match(/\A[0-9a-f\-]{36}\z/)
    end
  end
end
