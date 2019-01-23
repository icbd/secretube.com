FactoryBot.define do
  factory :user do

    transient do
      random_name {"#{SecureRandom.alphanumeric(5)}"}
      pswd {"PASSWORD"}
    end

    email {"#{random_name}@secretube.com"}
    password_digest {Tools.digest_calc(pswd)}
    email_valid {true}
    nickname {"#{random_name}"}
    created_at {10.day.ago}
    updated_at {1.day.ago}
  end
end
