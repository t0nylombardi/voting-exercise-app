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
require "rails_helper"

RSpec.describe Candidate, type: :model do
  subject { build(:candidate) }

  it { is_expected.to be_valid }

  it { should validate_presence_of(:name) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:users).through(:votes) }

  it "assigns UUID on create" do
    candidate = create(:candidate)
    expect(candidate.id).to be_present
    expect(candidate.id).to match(/\A[0-9a-f\-]{36}\z/)
  end
end
