require 'spec_helper'

describe InboundMailMailer do
  subject { InboundMailMailer }

  describe 'inbound_mail' do
    let(:msg) { {'email' => 'to@example.com', 'from_email' => 'from@example.com', 'from_name' => 'Joe User', 'text' => 'The body of the mail', 'raw_message' => 'The raw mail message'} }
    let(:payload) { {'tc' => Time.now.to_s, 'msg' => msg} }
    let(:mail) { subject.inbound_mail(payload) }

    it 'should render the subject' do
      mail.subject.should eq("OR Strings Inbound Email: #{msg['from_email']}")
    end

    it 'should set the recipient' do
      mail.to.should_not be_nil
    end

    it 'should set the sender' do
      mail.from.should_not be_nil
    end

    it 'should set the body' do
      mail.body.should_not be_nil
    end
  end
end
