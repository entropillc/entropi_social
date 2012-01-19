class CreateAccesses < ActiveRecord::Migration
  def change
    create_table :accesses do |t|
      t.integer :group_id
      t.references :accessible, :polymorphic => true
      t.timestamps
    end
    
    add_index :accesses, :group_id
    add_index :accesses, :accessible_id
    add_index :accesses, :accessible_type
  end
end
