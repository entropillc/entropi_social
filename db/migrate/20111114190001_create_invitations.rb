class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer   :requestor_id
      t.integer   :invited_id
      t.string    :email
      t.boolean   :string
      t.string    :token
      t.datetime  :sent_at
      t.datetime  :accepted_at
      t.timestamps
    end
  end
end
