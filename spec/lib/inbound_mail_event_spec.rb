require 'spec_helper'

describe InboundMailEvent do
  subject { InboundMailEvent.new(payload) }
  let(:payload) { {:msg => { }} }

  describe 'initialization' do

    its(:payload) { should eq(payload) }
  end

  describe 'methods' do

    describe '#process' do
      before do
        @mailer = double(:mailer, :deliver => nil)
        InboundMailMailer.stub(:inbound_mail).and_return(@mailer)
      end

      it 'should deliver the mailer' do
        @mailer.should_receive(:deliver).once
        subject.process
      end

      it 'should create an InboundMailMailer using the payload' do
        InboundMailMailer.should_receive(:inbound_mail).with(payload).once
        subject.process
      end
    end
  end
end
