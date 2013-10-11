# == Schema Information
#
# Table name: signatures
#
#  id           :integer          not null, primary key
#  email        :string(255)
#  first_name   :string(255)
#  last_name    :string(255)
#  town         :string(255)
#  ip           :string(255)
#  is_visible   :boolean
#  can_email    :boolean
#  confirmed_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe Signature do

  describe 'associations' do
    it { should have_many(:invites) }
    it { should have_one(:invite) }
    it { should have_many(:invitees).through(:invites) }
    it { should have_one(:inviter).through(:invite) }
    it { should have_many(:confirmations) }
  end

  describe 'validations' do
    subject { FactoryGirl.build(:signature) }
  end

  describe 'attributes' do
    subject { FactoryGirl.build(:signature) }

    { :email         => {:assignable => true,  :value => 'foo@example.com'},
      :first_name    => {:assignable => true,  :value => 'Bart'},
      :last_name     => {:assignable => true,  :value => 'Simpson'},
      :town          => {:assignable => true,  :value => 'Springfield'},
      :ip            => {:assignable => false, :value => '1.2.3.4'},
      :is_visible    => {:assignable => true,  :value => true},
      :can_email     => {:assignable => true,  :value => true},
      :confimed_at   => {:assignable => false, :value => Time.now} }.each do |k,v|

      describe "#{k}" do

        if v[:assignable]
          it 'should allow mass assignment' do
            lambda { subject.update_attributes(k => v[:value]) }.should_not raise_error
          end
        else
          it 'should not allow mass assignment' do
            lambda { subject.update_attributes(k => v[:value]) }.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
          end
        end
      end
    end

    it 'should downcase email addresses' do
      subject.email = 'FOO@example.com'
      subject.save
      subject.email.should eq('foo@example.com')
    end

    it 'should strip whitespace from email addresses' do
      subject.email = 'foo @example.com'
      subject.save
      subject.email.should eq('foo@example.com')
    end
  end

  describe 'scopes' do
    before do
      @p1 = FactoryGirl.create(:signature, :confirmed)
      @p2 = FactoryGirl.create(:signature)
    end

    describe 'confirmed' do

      it 'should return confirmed signatures' do
        Signature.confirmed.should eq([@p1])
      end

      it 'should return confirmed signatures in reverse chronological order' do
        @p3 = FactoryGirl.create(:signature, :confirmed_at => @p1.confirmed_at - 1.minute)
        Signature.confirmed.should eq([@p1, @p3])
        @p3.update_attribute(:confirmed_at, @p1.confirmed_at + 1.minute)
        Signature.confirmed.should eq([@p3, @p1])
      end
    end

    describe 'unconfirmed' do

      it 'should return unconfirmed signatures' do
        Signature.unconfirmed.should eq([@p2])
      end
    end
  end

  describe 'methods' do

    describe '#name' do
      its(:name) { should eq("#{subject.first_name} #{subject.last_name}") }
    end

    describe '#confirmed?' do
      context 'unconfirmed' do
        its(:confirmed?) { should_not be_true }
      end

      context 'confirmed' do
        before { subject.confirmed_at = Time.now }

        its(:confirmed?) { should be_true }
      end
    end

    describe '#confirmation' do
      before { @last_confirmation = FactoryGirl.create(:confirmation, :signature => subject) }

      it 'should return the more recent confirmation' do
        subject.confirmation.should eq(@last_confirmation)
      end
    end
  end
end
