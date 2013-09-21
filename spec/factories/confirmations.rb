FactoryGirl.define do
  factory :confirmation do
    signature
    token nil
    ip nil
    sent_at nil
    confirmed_at nil

    trait :sent do
      sent_at DateTime.now
    end

    trait :confirmed do
      ip  { "#{rand(256)}.#{rand(256)}.#{rand(256)}.#{rand(256)}" }
      confirmed_at DateTime.now
    end
  end
end
