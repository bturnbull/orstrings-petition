require 'spec_helper'

describe PetitionsController do

  describe '#show' do
    before do
      @signed   = FactoryGirl.create(:signature, :confirmed)
      @unsigned = FactoryGirl.create(:signature)
    end

    it 'should assign confirmed signatures as @signatures' do
      get :show
      assigns(:signatures).should eq([@signed])
    end
  end
end
