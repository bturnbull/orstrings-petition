FactoryGirl.define do
  factory :petitioner, :aliases => [:sender, :recipient] do
    sequence(:email) {|n| "joe.user#{n}@example.com"}
    first_name 'Joe'
    last_name 'User'
    town 'Durham'
    is_visible true
    can_email true
    signing_token {Digest::MD5.hexdigest(Time.now.to_s)}
    signed_at DateTime.now

    trait :private do
      is_visible false
    end

    trait :uninterested do
      can_email false
    end

    trait :unsigned do
      signed_at nil
    end

    factory :petitioner_with_invites do
      ignore do
        invite_count 3
      end

      after(:create) do |sender, evaluator|
        FactoryGirl.create_list(:invite, evaluator.invite_count, :sender => sender)
      end
    end

    factory :invited_petitioner do
      after(:create) do |recipient, evaluator|
        FactoryGirl.create(:invite, :recipient => recipient)
      end
    end
  end
end
