# == Schema Information
#
# Table name: confirmations
#
#  id           :integer          not null, primary key
#  signature_id :integer
#  token        :string(255)
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
    end
  end

  describe 'methods' do

    describe 'to_param' do
      its(:to_param) { should eq(subject.token) }
    end
  end

end
