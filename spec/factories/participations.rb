FactoryBot.define do
  factory :participation do
    id { "MyString" }
    user_id { "MyString" }
    has_voted { false }
    has_written_in { false }
    voted_at { "2025-07-15 19:25:21" }
    device_type { "MyString" }
  end
end
