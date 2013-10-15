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

  validates :email,      :presence  => true
  validates :first_name, :presence  => true
  validates :last_name,  :presence  => true
  validates :town,       :inclusion => %w{ Durham Lee Madbury Other }

  attr_accessible :email, :first_name, :last_name, :town, :is_visible, :can_email

  # temporarily set is_visible to true and clean up names and email addresses
  before_create do
    self.is_visible = true
    self.email = email.downcase.gsub(/\s+/, '')
    first_name.capitalize! if first_name.match(/^[a-z]+$/)
    last_name.capitalize! if last_name.match(/^[a-z ]+$/)
  end

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
