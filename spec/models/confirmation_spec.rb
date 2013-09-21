# == Schema Information
#
# Table name: confirmations
#
#  id           :integer          not null, primary key
#  signature_id :integer
#  token        :string(255)
#  ip           :string(255)
#  sent_at      :datetime
#  confirmed_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe Confirmation do
  subject { FactoryGirl.create(:confirmation) }

  describe 'associations' do
    it { should belong_to(:signature) }
  end

  describe 'validations' do

    describe 'token' do
      it 'should be present' do
        subject.token = nil
        subject.should_not be_valid
      end

      it 'should be an MD5 hex digest' do
        subject.token = 'foo'
        subject.should_not be_valid
      end

      it 'should be unique' do
        @confirmation = FactoryGirl.create(:confirmation)
        @confirmation.token = subject.token
        @confirmation.should_not be_valid
      end
    end
  end

  describe 'attributes' do

    describe 'token' do

      it 'should generate a token' do
        @confirmation = FactoryGirl.build(:confirmation, :token => nil)
        @confirmation.save
        @confirmation.token.should_not be_nil
      end

      it 'should not regenerate the token' do
        subject.token = nil
        subject.save.should_not be_true
        subject.token.should be_nil
      end

      it 'should not be mass assignable' do
        lambda {
          subject.update_attributes(:token => Digest::MD5.hexdigest('foo'))
        }.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
      end
    end

    its(:ip) { should be_nil }
    its(:confirmed_at) { should be_nil }
    its(:sent_at) { should be_nil }
  end

  describe 'methods' do

    describe '#to_param' do
      its(:to_param) { should eq(subject.token) }
    end

    describe '#confirmed?' do

      it 'should be true if record confirmed' do
        subject.confirmed_at = Time.now
        subject.confirmed?.should be_true
      end

      it 'should not be true if record unconfirmed' do
        subject.confirmed?.should_not be_true
      end
    end
  end

end
