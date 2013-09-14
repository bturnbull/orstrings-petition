FactoryGirl.define do
  factory :signature do
    sequence(:email) {|n| "joe.user#{n}@example.com"}
    first_name 'Joe'
    last_name 'User'
    town 'Durham'
    is_visible true
    can_email true
    confirmed_at nil

    trait :private do
      is_visible false
    end

    trait :uninterested do
      can_email false
    end

    trait :confirmed do
      confirmed_at Time.now
    end

    factory :signature_with_invites do
      ignore do
        invite_count 3
      end

      after(:create) do |sender, evaluator|
        FactoryGirl.create_list(:invite, evaluator.invite_count, :sender => sender)
      end
    end

    factory :invited_signature do
      after(:create) do |recipient, evaluator|
        FactoryGirl.create(:invite, :recipient => recipient)
      end
    end
  end
end
