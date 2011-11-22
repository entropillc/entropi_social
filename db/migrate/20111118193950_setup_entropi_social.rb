class SetupEntropiSocial < ActiveRecord::Migration
  def up
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
    
    # Setup Indexes for Users table
    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :unlock_token,         :unique => true
    
    create_table :profiles do |t|
      t.string :first_name
      t.string :last_name
      t.string :website
      t.string :blog
      t.string :avatar
      t.text :about
      t.timestamps
    end
    
    create_table :groups do |t|
      t.string :title
      t.references :user
      t.references :groupable, :polymorphic => true
      t.timestamps
    end
    
    create_table :friendships do |t|
      t.integer :inviter_id
      t.integer :invited_id
      t.column :status
      t.timestamps
    end
    
    create_table :memberships do |t|
      t.integer :group_id
      t.integer :user_id
      t.boolean :admin
      t.timestamps
    end
    
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
    
    create_table :comments do |t|
      t.string :title
      t.text  :body
      t.integer :user_id
      t.references :groupable, :polymorphic => true
      t.timestamps
    end
    
    create_table :likes do |t|
      t.integer :user_id
      t.references :likable, :polymorphic => true
      t.timestamps
    end
    
    # Create Default User
    User.create!(:first_name => 'System', :last_name => 'Administrator', :username => 'timeline', :birth_date => Time.now, :email => 'administrator@timeline.com', :password => 'password', :password_confirmation => "password")
    
  end

  def down
    
    drop_table :users
    drop_table :profiles
    drop_table :groups
    drop_table :friendships
    drop_table :memberships
    drop_table :invitations
    drop_table :comments
    drop_table :likes
    
  end
end
