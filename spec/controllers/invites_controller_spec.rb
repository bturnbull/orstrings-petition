require 'spec_helper'

describe InvitesController do
  before { @sender = FactoryGirl.create(:signature) }

  describe '#show' do
    before do
      @invite = FactoryGirl.create(:invite, :sender => @sender)
      get :show, :id => @invite.token
    end

    context 'valid token' do
      it 'should redirect to new signature' do
        response.should redirect_to(new_petition_signature_url)
      end

      it 'should set session data'
    end

    context 'invalid token' do
      it 'should render invalid token'
    end
  end
end
