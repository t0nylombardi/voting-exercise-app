# frozen_string_literal: true

require "rails_helper"

RSpec.describe Vote, type: :model do
  let(:user) { create(:user) }
  let(:candidate) { create(:candidate) }
  subject { build(:vote, user: user, candidate: candidate) }

  it { is_expected.to be_valid }

  it { should belong_to(:user) }
  it { should belong_to(:candidate) }

  # presence validation tests must be wrapped
  describe "validations" do
    before { allow(subject).to receive(:user).and_return(nil) }

    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:candidate_id) }
  end

  it "assigns UUID on create" do
    vote = create(:vote, user: user, candidate: candidate)
    expect(vote.id).to be_present
    expect(vote.id).to match(/\A[0-9a-f\-]{36}\z/)
  end
end
