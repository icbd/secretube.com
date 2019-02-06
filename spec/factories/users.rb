FactoryBot.define do
  factory :user do
    transient do
      pswd { 'PASSWORD' }
    end

    uuid { SecureRandom.uuid }
    email { Faker::Internet.email }
    password_digest { Tools.digest_calc(pswd) }
    email_valid { true }
    nickname { Faker::Name }
    created_at { 10.day.ago }
    updated_at { 1.day.ago }
  end
end
