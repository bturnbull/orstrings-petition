require 'spec_helper'

describe ApplicationController do

  describe 'methods' do

    describe 'remote_ip' do
      before do
        request.stub(:env).and_return({'HTTP_X_FORWARDED_FOR' => '4.3.2.1'})
        request.stub(:remote_ip).and_return('1.2.3.4')
      end

      it 'should return HTTP_X_FORWARDED_FOR env' do
        subject.remote_ip.should eq('4.3.2.1')
      end

      it 'should return REMOTE_IP when no proxy' do
        request.stub(:env).and_return({})
        subject.remote_ip.should eq('1.2.3.4')
      end
    end
  end
end
