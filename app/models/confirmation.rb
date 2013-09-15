# == Schema Information
#
# Table name: confirmations
#
#  id           :integer          not null, primary key
#  signature_id :integer
#  token        :string(255)
#  ip           :string(255)
#  confirmed_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Confirmation < ActiveRecord::Base
  belongs_to :signature

  validates :token, :presence   => true,
                    :uniqueness => true,
                    :token      => true

  before_validation :generate_token

  def to_param
    token
  end

  def confirmed?
    !!confirmed_at
  end

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
