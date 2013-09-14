FactoryGirl.define do
  factory :confirmation do
    signature
    token { Digest::MD5.hexdigest(Time.now.to_s + rand(1048576).to_s) }
    confirmed_at DateTime.now

    trait :unconfirmed do
      confirmed_at nil
    end
  end
end
