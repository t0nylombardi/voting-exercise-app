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
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "iForgotMyPwdAgain" }
    zip_code { Faker::Address.zip_code }
  end
end
