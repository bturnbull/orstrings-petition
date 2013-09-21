require 'spec_helper'

describe ConfirmationConfirmer do

  describe 'attributes' do

    describe '#ip' do
      let(:ip) { '1.2.3.4' }

      it 'should be nil by default' do
        subject.ip.should be_nil
      end

      it 'should be set by :ip option' do
        subject.class.new(:ip => ip).ip.should eq(ip)
      end
    end

    describe '#confirmation' do
      let(:confirmation) { FactoryGirl.build(:confirmation) }

      it 'should be nil by default' do
        subject.confirmation.should be_nil
      end

      it 'should be set by the :confirmation option' do
        subject.class.new(:confirmation => confirmation).confirmation.should eq(confirmation)
      end
    end

    describe '#confirmed_at' do
      before do
        @now = Time.now
        Time.stub(:now).and_return(@now)
      end

      it 'should be Time.now by default' do
        subject.confirmed_at.should eq(@now)
      end

      it 'should be set by the :confirmed_at option' do
        subject.class.new(:confirmed_at => Time.now - 1.hour).confirmed_at.should eq(Time.now - 1.hour)
      end
    end
  end

  describe 'methods' do

    describe '#confirm' do
      subject { ConfirmationConfirmer.new(:ip => ip, :confirmation => confirmation) }

      let(:ip) { '1.2.3.4' }

      before do
        @now = Time.now
        Time.stub(:now).and_return(@now)
      end

      context 'unconfirmed' do
        let(:confirmation) { FactoryGirl.create(:confirmation) }

        after { subject.confirm }

        it 'should set ip' do
          confirmation.should_receive(:ip=).with(ip).once
        end

        it 'should set confirmed_at' do
          confirmation.should_receive(:confirmed_at=).with(@now).once
        end

        it 'should update the confirmation' do
          confirmation.should_receive(:save).once
        end

        it 'should set confirmed_at on associated signature' do
          confirmation.signature.should_receive(:update_attribute).with(:confirmed_at, @now).once
        end

        it 'should return true' do
          subject.confirm.should be_true
        end
      end

      context 'confirmed' do
        let(:confirmation) { FactoryGirl.create(:confirmation, :confirmed) }

        after { subject.confirm }

        it 'should not set ip' do
          confirmation.should_receive(:ip=).never
        end

        it 'should not set confirmed_at' do
          confirmation.should_receive(:confirmed_at=).never
        end

        it 'should not update the confirmation' do
          confirmation.should_receive(:save).never
        end

        it 'should not set confirmed_at on associated signature' do
          confirmation.signature.should_receive(:update_attributes).never
        end

        it 'should not return true' do
          subject.confirm.should_not be_true
        end
      end

    end
  end
end

