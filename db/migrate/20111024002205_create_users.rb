class Users < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string    :first_name
      t.string    :last_name
      t.string    :username
      t.date      :birth_date
      t.integer   :invitation_limit,  :default => 0
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable
      t.lockable  :lock_strategy => :failed_attempts, :unlock_strategy => :both
      t.timestamps
    end
    
    # Indexes for Users Table
    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :unlock_token,         :unique => true
    add_index :users, :invitation_token
    add_index :users, :invited_by_id
    
    # Create initial system user  
    User.create!(:first_name => 'System', :last_name => 'Administrator', :username => 'timeline', :birth_date => Time.now, :email => 'administrator@timeline.com', :password => 'password', :password_confirmation => "password")
  end
  
  def self.down
    drop_table :users
  end
end
