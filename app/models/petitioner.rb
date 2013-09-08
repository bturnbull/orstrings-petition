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
  # attr_accessible :title, :body
end
