require 'spec_helper'

describe SelfInviteValidator do
  subject { SelfInviteValidator.new(:attributes => [:recipient]) }
  let(:record) { FactoryGirl.build(:invite) }

  it 'should have no errors' do
    record.errors.should be_empty
  end

  context 'different sender and recipient' do
    it 'should validate' do
      subject.validate(record)
      record.errors[:recipient].should be_empty
    end
  end

  context 'sender sending to self' do
    it 'should not validate' do
      record.recipient = record.sender
      subject.validate(record)
      record.errors[:recipient].should_not be_empty
    end

    it 'should set useful error message' do
      record.recipient = record.sender
      subject.validate(record)
      record.errors[:recipient].should eq(["can't invite themselves"])
    end
  end
end
