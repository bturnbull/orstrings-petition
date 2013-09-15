require 'spec_helper'

describe ConfirmationsController do
  before { @conf = FactoryGirl.create(:confirmation) }

  describe '#show' do
    before do
      @now = Time.now
      Time.stub(:now).and_return(@now)
      @ip = '5.6.7.8'
      subject.stub(:remote_ip).and_return(@ip)
    end

    context 'valid token' do
      before { get :show, :id => @conf.token }

      it 'should redirect to signature page' do
        @conf.stub(:confirmed?).and_return(true)
        response.should redirect_to(petition_signature_url(@conf.signature))
      end

      it 'should set confirmed_at attribute to current time' do
        @conf.reload
        @conf.confirmed_at.should eq(@now)
      end

      it 'should set ip attribute' do
        @conf.reload
        @conf.ip.should eq(@ip)
      end

      it 'should confirm associated siganture' do
        @conf.signature.reload
        @conf.signature.confirmed?.should be_true
      end
    end

    context 'invalid token' do
      it 'should render invalid token'
    end
  end
end
