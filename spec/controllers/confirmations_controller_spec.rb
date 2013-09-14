require 'spec_helper'

describe ConfirmationsController do
  before { @conf = FactoryGirl.create(:confirmation) }

  describe '#show' do
    before do
      get :show, :id => @conf.token
    end

    context 'valid token' do
      it 'should redirect to signature page' do
        response.should redirect_to(petition_signature_url(@conf.signature))
      end
    end

    context 'invalid token' do
      it 'should render invalid token'
    end
  end
end
