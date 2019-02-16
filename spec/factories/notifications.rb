FactoryBot.define do
  factory :notification do
    user
    content { 'Hello' }
    category { :notify }
  end
end
