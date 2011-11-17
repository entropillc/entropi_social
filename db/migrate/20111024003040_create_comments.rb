class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :title
      t.text  :body
      t.integer :user_id
      t.references :groupable, :polymorphic => true
      t.timestamps
    end
  end
end
