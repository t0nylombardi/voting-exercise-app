# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  subject { build(:user) }

  it { is_expected.to be_valid }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:zip_code) }

  it { should have_one(:participation).dependent(:destroy) }
  it { should have_many(:votes) }
  it { should have_many(:candidates).through(:votes) }

  it "assigns UUID on create" do
    user = create(:user)
    expect(user.id).to be_present
    expect(user.id).to match(/\A[0-9a-f\-]{36}\z/)
  end
end
