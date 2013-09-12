require 'spec_helper'

describe PetitionsController do

  describe '#show' do
    before do
      @signed   = FactoryGirl.create(:petitioner)
      @unsigned = FactoryGirl.create(:petitioner, :unsigned)
    end

#    it 'should assign signed petitioners as @petitioners' do
#      get :show
#      assigns(:petitioners).should eq([@signer])
#    end
  end
end
