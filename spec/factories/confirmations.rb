FactoryGirl.define do
  factory :confirmation do
    signature
    token nil
    ip nil
    confirmed_at nil

    trait :confirmed do
      ip  { "#{rand(256)}.#{rand(256)}.#{rand(256)}.#{rand(256)}" }
      confirmed_at DateTime.now
    end
  end
end
