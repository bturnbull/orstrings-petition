# == Schema Information
#
# Table name: petitioners
#
#  id            :integer          not null, primary key
#  email         :string(255)
#  first_name    :string(255)
#  last_name     :string(255)
#  town          :string(255)
#  is_visible    :boolean
#  can_email     :boolean
#  signing_token :string(255)
#  signed_at     :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'spec_helper'

describe Petitioner do

  describe 'associations' do
    it { should have_many(:invites) }
    it { should have_one(:invite) }
    it { should have_many(:invitees).through(:invites) }
    it { should have_one(:inviter).through(:invite) }
  end

  describe 'validations' do
    subject { FactoryGirl.build(:petitioner) }
  end

  describe 'attributes' do

    { :email         => {:assignable => true,  :value => 'foo@example.com'},
      :first_name    => {:assignable => true,  :value => 'Bart'},
      :last_name     => {:assignable => true,  :value => 'Simpson'},
      :town          => {:assignable => true,  :value => 'Springfield'},
      :is_visible    => {:assignable => false, :value => true},
      :can_email     => {:assignable => false, :value => true},
      :signing_token => {:assignable => false, :value => '0123456789ABCDEF0123456789ABCDEF' } }.each do |k,v|

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
  end

  describe 'scopes' do
    before do
      @p1 = FactoryGirl.create(:petitioner)
      @p2 = FactoryGirl.create(:petitioner, :unsigned)
    end

    describe 'signed' do

      it 'should return signed petitioners' do
        Petitioner.signed.should eq([@p1])
      end

      it 'should return signed petitioners in reverse chronological order' do
        @p3 = FactoryGirl.create(:petitioner, :signed_at => @p1.signed_at - 1.minute)
        Petitioner.signed.should eq([@p1, @p3])
        @p3.update_attribute(:signed_at, @p1.signed_at + 1.minute)
        Petitioner.signed.should eq([@p3, @p1])
      end
    end

    describe 'unsigned' do

      it 'should return unsigned petitioners' do
        Petitioner.unsigned.should eq([@p2])
      end
    end
  end

  describe 'methods' do

    describe '#name' do
      its(:name) { should eq("#{subject.first_name} #{subject.last_name}") }
    end
  end
end
