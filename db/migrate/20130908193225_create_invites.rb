class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.integer    :recipient_id
      t.integer    :sender_id
      t.string     :token
      t.datetime   :sent_at
      t.timestamps
    end
  end
end
