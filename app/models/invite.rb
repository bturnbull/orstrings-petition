# == Schema Information
#
# Table name: invites
#
#  id           :integer          not null, primary key
#  recipient_id :integer
#  sender_id    :integer
#  sent_at      :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Invite < ActiveRecord::Base
  belongs_to :sender,    :class_name => 'Petitioner'
  belongs_to :recipient, :class_name => 'Petitioner'

  validates :sender,       :presence    => true
  validates :recipient,    :presence    => true,
                           :self_invite => true
  validates :recipient_id, :uniqueness  => true

  attr_accessible :sender, :recipient
end
