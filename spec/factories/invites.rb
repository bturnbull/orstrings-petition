FactoryGirl.define do
  factory :invite do
    association :sender,    :factory => :petitioner
    association :recipient, :factory => :petitioner
    sent_at DateTime.now
  end
end
