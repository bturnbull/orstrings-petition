require 'spec_helper'

describe ConfirmationMailer do
  subject { ConfirmationMailer }

  describe 'confirmation' do
    let(:confirmation) { FactoryGirl.create(:confirmation) }
    let(:mail) { subject.confirmation(confirmation) }

    it 'should render the subject' do
      mail.subject.should eq('OR Strings Petition Signature Confirmation')
    end

    it 'should set the recipient' do
      mail.to.should eq([confirmation.signature.email])
    end

    it 'should set the sender' do
      mail.from.should eq(['confirm@orstrings.org'])
    end

    it 'should set the body' do
      mail.body.should_not be_nil
    end
  end
end
