# == Schema Information
#
# Table name: invites
#
#  id           :integer          not null, primary key
#  recipient_id :integer
#  sender_id    :integer
#  sent_at      :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe Invite do

  describe 'associations' do
    it { should belong_to(:sender) }
    it { should belong_to(:recipient) }
  end

  describe 'validations' do
    subject { FactoryGirl.build(:invite) }

    describe 'sender' do
      it 'should be present' do
        subject.sender = nil
        subject.should_not be_valid
      end
    end

    describe 'recipient' do
      it 'should be present' do
        subject.recipient = nil
        subject.should_not be_valid
      end

      it 'should be unique' do
        subject.save
        other = FactoryGirl.build(:invite, :recipient => subject.recipient)
        other.should_not be_valid
      end

      it 'should not be same as sender' do
        subject.recipient = subject.sender
        subject.should_not be_valid
      end
    end

  end

end
