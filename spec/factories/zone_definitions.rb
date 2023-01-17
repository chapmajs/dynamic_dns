FactoryBot.define do

  factory :zone do
    sequence(:name) { |n| "subdomain#{n}.example.com" } 
    serial { "#{Time.now.strftime("%Y%m%d").to_i}00".to_i }
  end

  factory :zone_with_records, :parent => :zone do

    after(:create) do |z|
      FactoryBot.create(:a_record, :zone_id => z.id)
      FactoryBot.create(:a_a_a_a_record, :zone_id => z.id)
    end
  end
end
