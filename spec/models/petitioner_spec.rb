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

end
