require 'spec_helper'

describe ConfirmationSender do
  subject { ConfirmationSender.new(confirmation) }

  let(:confirmation) { FactoryGirl.create(:confirmation) }
  let(:message) { double(:message, :deliver => true) }

  describe 'attributes' do

    describe '#message' do

      it 'should use ConfirmationMailer by default' do
        ConfirmationMailer.should_receive(:confirmation).with(confirmation).once
        subject.message
      end

      it 'should be set by :message option' do
        subject.class.new(confirmation, :message => message).message.should eq(message)
      end
    end

    describe '#confirmation' do
      let(:confirmation) { FactoryGirl.build(:confirmation) }

      it 'should be set by first initialize argument' do
        subject.class.new(confirmation).confirmation.should eq(confirmation)
      end
    end

    describe '#sent_at' do
      before do
        @now = Time.now
        Time.stub(:now).and_return(@now)
      end

      it 'should be Time.now by default' do
        subject.sent_at.should eq(@now)
      end

      it 'should be set by the :sent_at option' do
        subject.class.new(confirmation, :sent_at => Time.now - 1.hour).sent_at.should eq(Time.now - 1.hour)
      end
    end
  end

  describe 'methods' do

    describe '#deliver' do
      subject { ConfirmationSender.new(confirmation, :message => message) }

      before do
        @now = Time.now
        Time.stub(:now).and_return(@now)
      end

      context 'unconfirmed' do
        let(:confirmation) { FactoryGirl.create(:confirmation) }

        after { subject.deliver }

        it 'should deliver the message' do
          message.should_receive(:deliver).once
        end

        it 'should set sent_at' do
          confirmation.should_receive(:update_attribute).with(:sent_at, @now).once
        end

        it 'should return true' do
          subject.deliver.should be_true
        end

        context 'delivery failure' do
          let(:message) { double(:message, :deliver => false) }

          it 'should return false' do
            subject.deliver.should_not be_true
          end
        end
      end

      context 'confirmed' do
        let(:confirmation) { FactoryGirl.create(:confirmation, :confirmed) }

        after { subject.deliver }

        it 'should not deliver' do
          message.should_receive(:deliver).never
        end

        it 'should not set sent_at' do
          confirmation.should_receive(:sent_at).never
        end

        it 'should not return true' do
          subject.deliver.should_not be_true
        end
      end

    end
  end
end

