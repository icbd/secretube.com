FactoryBot.define do
  factory :user do
    transient do
      pswd { 'PASSWORD' }
    end

    email { Faker::Internet.email }
    password_digest { Tools.digest_calc(pswd) }
  end
end
