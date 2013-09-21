class CreateConfirmations < ActiveRecord::Migration
  def change
    create_table :confirmations do |t|
      t.integer  :signature_id
      t.string   :token
      t.string   :ip
      t.datetime :sent_at
      t.datetime :confirmed_at
      t.timestamps
    end
  end
end
