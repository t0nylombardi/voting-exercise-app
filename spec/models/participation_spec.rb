# frozen_string_literal: true

require "rails_helper"

RSpec.describe Participation, type: :model do
  let(:user) { create(:user) }
  subject { build(:participation, user: user) }

  it { is_expected.to be_valid }

  it { should belong_to(:user) }
  it { should validate_presence_of(:user_id) }

  it "assigns UUID on create" do
    participation = create(:participation, user: user)
    expect(participation.id).to be_present
    expect(participation.id).to match(/\A[0-9a-f\-]{36}\z/)
  end
end
