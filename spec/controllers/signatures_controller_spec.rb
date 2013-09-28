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

    it 'should enable is_visible' do
      assigns(:signature).is_visible?.should be_true
    end

    it 'should enable can_email' do
      assigns(:signature).can_email?.should be_true
    end
  end

  describe '#create' do

    context 'valid attributes' do
      before do
        @ip = '5.6.7.8'
        subject.stub(:remote_ip).and_return(@ip)
        post :create, :signature => valid_attributes
      end

      context 'new' do
        before { post :create, :signature => valid_attributes }

        it 'should create a new signature' do
          expect {
            valid_attributes[:email] = 'foo@example.com'
            post :create, :signature => valid_attributes
          }.to change(Signature, :count).by(1)
        end

        it 'should assign a created signature to @signature' do
          assigns(:signature).should be_a(Signature)
        end

        it 'should persist a signature' do
          assigns(:signature).should be_persisted
        end

        it 'should save the ip address' do
          Signature.last.ip.should eq(@ip)
        end

        it 'should persist a confirmation' do
          expect {
            post :create, :signature => valid_attributes
          }.to change(Confirmation, :count).by(1)
        end

        it 'should redirect to the created signature' do
          response.should redirect_to(petition_signature_url(assigns(:signature)))
        end
      end

      context 'dupe unconfirmed' do
        before do
          @signature = FactoryGirl.create(:signature)
          FactoryGirl.create(:confirmation, :signature => @signature)
        end

        it 'should not create a new signature' do
          expect {
            post :create, :signature => {:email      => @signature.email,
                                         :first_name => @signature.first_name,
                                         :last_name  => @signature.last_name}
          }.to change(Signature, :count).by(0)
        end

        it 'should assign a created signature to @signature' do
          assigns(:signature).should be_a(Signature)
        end

        it 'should persist a signature' do
          assigns(:signature).should be_persisted
        end

        it 'should save the ip address' do
          assigns(:signature).ip.should eq(@ip)
        end

        it 'should persist a confirmation' do
          expect {
            post :create, :signature => valid_attributes
          }.to change(Confirmation, :count).by(1)
        end

        it 'should redirect to the existing signature' do
          response.should redirect_to(petition_signature_url(assigns(:signature)))
        end

        it 'should not set a flash message' do
          flash.keys.should be_empty
        end
      end

      context 'limit unconfirmed' do
        before do
          @signature = FactoryGirl.create(:signature)
          3.times { FactoryGirl.create(:confirmation, :signature => @signature) }
          post :create, :signature => {:email      => @signature.email,
                                       :first_name => @signature.first_name,
                                       :last_name  => @signature.last_name}
        end

        it 'should not create a new signature' do
          expect {
            post :create, :signature => {:email      => @signature.email,
                                         :first_name => @signature.first_name,
                                         :last_name  => @signature.last_name}
          }.to change(Signature, :count).by(0)
        end

        it 'should redirect to the petition url' do
          response.should redirect_to(petition_url)
        end

        it 'should set a flash error message' do
          flash[:error].should_not be_nil
        end
      end

      context 'confirmed' do
        before do
          @signature = FactoryGirl.create(:signature, :confirmed)
          post :create, :signature => {:email      => @signature.email,
                                       :first_name => @signature.first_name,
                                       :last_name  => @signature.last_name}
        end

        it 'should not create a new signature' do
          expect {
            post :create, :signature => {:email      => @signature.email,
                                         :first_name => @signature.first_name,
                                         :last_name  => @signature.last_name}
          }.to change(Signature, :count).by(0)
        end

        it 'should redirect to the petition url' do
          response.should redirect_to(petition_url)
        end

        it 'should set a flash warning message' do
          flash[:warning].should_not be_nil
        end
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
