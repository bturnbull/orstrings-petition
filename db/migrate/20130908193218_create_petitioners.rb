class CreatePetitioners < ActiveRecord::Migration
  def change
    create_table :petitioners do |t|
      t.string     :email
      t.string     :first_name
      t.string     :last_name
      t.string     :town
      t.boolean    :is_visible
      t.boolean    :can_email
      t.string     :signing_token
      t.datetime   :signed_at
      t.timestamps
    end
  end
end
