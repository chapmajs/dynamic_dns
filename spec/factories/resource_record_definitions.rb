FactoryBot.define do

  factory :a_record do
    sequence(:name) { |n| "host#{n}.example.com" }
    sequence(:data) { |n| "1.2.3.#{n}" }
    ttl { 300 }
  end

  factory :a_a_a_a_record do
    sequence(:name) { |n| "host#{n}.example.com" }
    sequence(:data) { |n| "2001:db8:1::#{n}" }
    ttl { 300 }
  end
end
