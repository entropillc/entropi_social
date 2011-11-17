class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :title
      t.references :user
      t.references :groupable, :polymorphic => true
      t.timestamps
    end
  end
end
