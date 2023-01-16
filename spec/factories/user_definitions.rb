FactoryBot.define do

  factory :user do
    sequence(:username) { |n| "user#{n}"} 
    password { 'testing' }
    password_confirmation { 'testing' }
  end
end
