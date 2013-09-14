require 'spec_helper'

describe SignaturesController do
  let(:valid_attributes) { { :first_name => 'Joe',
                             :last_name => 'User',
                             :email => 'joe.user@example.com',
                             :town => 'Durham' } }
  let(:invalid_attributes) { { } }

  describe '#index' do
    before do
      @signature = FactoryGirl.create(:signature, :confirmed)
      get :index
    end

    it 'should assign all signatures to @signatures' do
      assigns(:signatures).should eq([@signature])
    end
  end

  describe '#show' do
    before do
      @signature = FactoryGirl.create(:signature)
      get :show, :id => @signature.id.to_s
    end

    it 'should assign signature to @signature' do
      assigns(:signature).should eq(@signature)
    end
  end

  describe '#new' do
    before do
      get :new
    end

    it 'should assign a new signature to @signature' do
      assigns(:signature).should be_a_new(Signature)
    end
  end

  describe '#create' do

    context 'valid attributes' do
      before { post :create, :signature => valid_attributes }

      it 'should create a new signature' do
        expect {
          post :create, :signature => valid_attributes
        }.to change(Signature, :count).by(1)
      end

      it 'should assign a created signature to @signature' do
        assigns(:signature).should be_a(Signature)
      end

      it 'should persist a signature' do
        assigns(:signature).should be_persisted
      end

      it 'should redirect to the created signature' do
        response.should redirect_to(petition_signature_url(Signature.last))
      end
    end

    context 'invalid attributes' do
      before do
        Signature.any_instance.stub(:save).and_return(false)
        post :create, :signature => invalid_attributes
      end

      it 'should assign a new signature to @signature' do
        assigns(:signature).should be_a_new(Signature)
      end

      it 'should render the new view' do
        response.should render_template('new')
      end

    end
  end
end
