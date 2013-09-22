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

class Signature < ActiveRecord::Base
  has_many :invites,  :class_name  => 'Invite',
                      :foreign_key => :sender_id
  has_one  :invite,   :class_name  => 'Invite',
                      :foreign_key => :recipient_id
  has_many :invitees, :through     => :invites,
                      :class_name  => 'Signature',
                      :source      => :recipient
  has_one  :inviter,  :through     => :invite,
                      :class_name  => 'Signature',
                      :source      => :sender
  has_many :confirmations

  validates :email, :presence => true

  attr_accessible :email, :first_name, :last_name, :town, :is_visible, :can_email

  scope :confirmed,    lambda { where('confirmed_at IS NOT NULL').order('confirmed_at DESC') }
  scope :unconfirmed,  lambda { where('confirmed_at IS NULL') }

  def name
    "#{first_name} #{last_name}"
  end

  def confirmed?
    !!confirmed_at
  end

  # return the most recent confirmation
  def confirmation
    confirmations.order(:created_at).last
  end
end
