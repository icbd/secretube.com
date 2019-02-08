FactoryBot.define do
  factory :machine do
    ipv4 { Faker::Internet.ip_v4_address }
  end
end
