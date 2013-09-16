require 'spec_helper'

describe MailerBase do

  context 'smtp_settings present' do
    before do
      @host = 'example.com'
      Orstrings::Application.config.action_mailer.stub(:smtp_settings).and_return({:domain => @host})
      Object.send(:remove_const, 'MailerBase')
      load Rails.root.join('app/mailers/mailer_base.rb')
    end

    it 'should configure default host to smtp_settings domain' do
      MailerBase.default_url_options[:host].should eq(@host)
    end
  end

  context 'smtp_setting absent' do
    #before do
    #  @host = 'example.com'
    #  Orstrings::Application.config.action_mailer.stub(:smtp_settings).and_return(nil)
    #  Object.send(:remove_const, 'MailerBase')
    #end

    #it 'should raise MailerBase::Exception' do
    #  lambda {
    #    Object.send(:remove_const, 'MailerBase')
    #    load Rails.root.join('app/mailers/mailer_base.rb')
    #  }.should raise_error
    #end
  end
end
