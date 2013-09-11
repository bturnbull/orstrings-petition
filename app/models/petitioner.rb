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

class Petitioner < ActiveRecord::Base
  has_many :invites,  :class_name  => 'Invite',
                      :foreign_key => :sender_id
  has_one  :invite,   :class_name  => 'Invite',
                      :foreign_key => :recipient_id
  has_many :invitees, :through     => :invites,
                      :class_name  => 'Petitioner',
                      :source      => :recipient
  has_one  :inviter,  :through     => :invite,
                      :class_name  => 'Petitioner',
                      :source      => :sender

  attr_accessible :email, :first_name, :last_name
end
