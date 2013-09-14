FactoryGirl.define do
  factory :invite do
    association :sender,    :factory => :signature
    association :recipient, :factory => :signature
    token { Digest::MD5.hexdigest(Time.now.to_s + rand(1048576).to_s) }
    sent_at DateTime.now
  end
end
