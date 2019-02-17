FactoryBot.define do
  factory :notification do
    transient do
      phone_number_valided_user { create(:user,
                                         phone_number_valid: true,
                                         phone_number: Faker::PhoneNumber.cell_phone) }
    end

    user { phone_number_valided_user }
    content { 'Hello' }
    category { :notify }
  end
end
