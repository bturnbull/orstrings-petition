# == Schema Information
#
# Table name: invites
#
#  id           :integer          not null, primary key
#  recipient_id :integer
#  sender_id    :integer
#  token        :string(255)
#  sent_at      :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Invite < ActiveRecord::Base
  belongs_to :sender,    :class_name => 'Signature'
  belongs_to :recipient, :class_name => 'Signature'

  validates :sender,       :presence    => true
  validates :recipient,    :presence    => true,
                           :self_invite => true
  validates :recipient_id, :uniqueness  => true
  validates :token,        :presence    => true,
                           :uniqueness  => true,
                           :token       => true

  before_validation :generate_token

  attr_accessible :sender, :recipient

private

  # generate a unique token for this record on create
  def generate_token
    return unless new_record?

    10.times do
      self.token = Digest::MD5.hexdigest(rand(1048576).to_s + Time.now.to_s)
      break unless self.class.where(:token => self.token).count > 0
    end
  end

end
