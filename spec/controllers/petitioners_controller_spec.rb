require 'spec_helper'

describe PetitionersController do
  let(:valid_attributes) { { } }
  let(:invalid_attributes) { { } }

  describe '#index' do
    before do
      @petitioner = FactoryGirl.create(:petitioner)
      get :index
    end

    it 'should assign all petitioners to @petitioners' do
      assigns(:petitioners).should eq([@petitioner])
    end
  end

  describe '#show' do
    before do
      @petitioner = FactoryGirl.create(:petitioner)
      get :show, :id => @petitioner.id.to_s
    end

    it 'should assign petititioner to @petitioner' do
      assigns(:petitioner).should eq(@petitioner)
    end
  end

  describe '#new' do
    before do
      get :new
    end

    it 'should assign a new petitioner to @petitioner' do
      assigns(:petitioner).should be_a_new(Petitioner)
    end
  end

  describe '#create' do

    context 'valid attributes' do
      before { post :create, :petitioner => valid_attributes }

      it 'should create a new petitioner' do
        expect {
          post :create, :petitioner => valid_attributes
        }.to change(Petitioner, :count).by(1)
      end

      it 'should assign a created petitioner to @petitioner' do
        assigns(:petitioner).should be_a(Petitioner)
      end

      it 'should persist a petitioner' do
        assigns(:petitioner).should be_persisted
      end

      it 'should redirect to the created petitioner' do
        response.should redirect_to(petition_signer_url(Petitioner.last))
      end
    end

    context 'invalid attributes' do
      before do
        Petitioner.any_instance.stub(:save).and_return(false)
        post :create, :petitioner => invalid_attributes
      end

      it 'should assign a new petitioner to @petitioner' do
        assigns(:petitioner).should be_a_new(Petitioner)
      end

      it 'should render the new view' do
        response.should render_template('new')
      end


    end
  end
end
