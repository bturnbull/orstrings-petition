require 'spec_helper'

describe InvitesController do
  let(:valid_attributes) { { :recipient_id => @recipient.id.to_s } }
  let(:invalid_attributes) { { } }

  before do
    @sender    = FactoryGirl.create(:petitioner)
    @recipient = FactoryGirl.create(:petitioner)
  end

  describe '#index' do
    before do
      @invite = FactoryGirl.create(:invite, :sender => @sender, :recipient => @recipient)
      get :index, :signer_id => @sender.id.to_s
    end

    it 'should assign all invites to @invites' do
      assigns(:invites).should eq([@invite])
    end
  end

  describe '#show' do
    before do
      @invite = FactoryGirl.create(:invite, :sender => @sender)
      get :show, :signer_id => @sender.id.to_s, :id => @invite.id.to_s
    end

    it 'should assign invite to @invite' do
      assigns(:invite).should eq(@invite)
    end
  end

  describe '#new' do
    before do
      get :new, :signer_id => @sender.id.to_s
    end

    it 'should assign a new invite to @invite' do
      assigns(:invite).should be_a_new(Invite)
    end
  end

  describe '#create' do
    context 'valid attributes' do
      before { post :create, :signer_id => @sender.id.to_s, :invite => valid_attributes }

      it 'should create a new invite' do
        expect {
          post :create, :signer_id => @sender.id.to_s, :invite => valid_attributes
        }.to change(Invite, :count).by(1)
      end

      it 'should assign a created invite to @invite' do
        assigns(:invite).should be_a(Invite)
      end

      it 'should persist am invite' do
        assigns(:invite).should be_persisted
      end

      it 'should redirect to the created invite' do
        response.should redirect_to(petition_signer_invite_url(@sender, Invite.last))
      end
    end

    context 'invalid attributes' do
      before do
        Invite.any_instance.stub(:save).and_return(false)
        post :create, :signer_id => @sender.id.to_s, :invite => invalid_attributes
      end

      it 'should assign a new invite to @invite' do
        assigns(:invite).should be_a_new(Invite)
      end

      it 'should render the new view' do
        response.should render_template('new')
      end

    end
  end
end
