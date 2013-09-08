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

require 'spec_helper'

describe Invite do
  pending "add some examples to (or delete) #{__FILE__}"
end
