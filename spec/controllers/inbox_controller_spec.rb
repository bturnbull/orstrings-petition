require 'spec_helper'

describe InboxController do

  describe '#handle_inbound' do
    let(:payload) { {:msg => {}} }

    before do
      @inbound_mail_event = double(:inbound_mail_event, :process => nil)
      InboundMailEvent.stub(:new).and_return(@inbound_mail_event)
    end

    it 'should deliver payload to InboundMailEvent object' do
      InboundMailEvent.should_receive(:new).with(payload).once
      subject.handle_inbound(payload)
    end

    it 'should process the InboundMailEvent' do
      @inbound_mail_event.should_receive(:process).once
      subject.handle_inbound(payload)
    end
  end
end
