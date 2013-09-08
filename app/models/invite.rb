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
  # attr_accessible :title, :body
end
