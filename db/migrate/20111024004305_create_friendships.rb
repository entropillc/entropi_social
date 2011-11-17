class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.integer :inviter_id
      t.integer :invited_id
      t.integer :status
      t.timestamps
    end
  end
end
