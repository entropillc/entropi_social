class AddAuthEngineToUsers < ActiveRecord::Migration
  def change
    add_column :users, :auth_engine, :string
  end
end
