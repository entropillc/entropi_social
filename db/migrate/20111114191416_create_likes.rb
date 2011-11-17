class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :user_id
      t.references :likable, :polymorphic => true
      t.timestamps
    end
  end
end
