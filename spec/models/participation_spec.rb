# frozen_string_literal: true

# == Schema Information
#
# Table name: participations
#
#  id             :string           not null, primary key
#  device_type    :string
#  has_voted      :boolean          default(FALSE)
#  has_written_in :boolean          default(FALSE)
#  voted_at       :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :string           not null
#
# Indexes
#
#  index_participations_on_user_id  (user_id) UNIQUE
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
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
