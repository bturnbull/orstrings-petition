class CreateSignatures < ActiveRecord::Migration
  def change
    create_table :signatures do |t|
      t.string     :email
      t.string     :first_name
      t.string     :last_name
      t.string     :town
      t.boolean    :is_visible
      t.boolean    :can_email
      t.datetime   :confirmed_at
      t.timestamps
    end
  end
end
