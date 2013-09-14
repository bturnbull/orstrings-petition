class CreateConfirmations < ActiveRecord::Migration
  def change
    create_table :confirmations do |t|
      t.integer  :signature_id
      t.string   :token
      t.datetime :confirmed_at
      t.timestamps
    end
  end
end
