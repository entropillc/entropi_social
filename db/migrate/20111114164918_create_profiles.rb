class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :first_name
      t.string :last_name
      t.string :website
      t.string :blog
      t.string :avatar
      t.text :about

      t.timestamps
    end
  end
end
