class SetupEntropiSocial < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.integer   :invitation_limit,  :default => 0
      t.database_authenticatable      :null => false
      t.invitable
      t.recoverable
      t.rememberable
      t.trackable
      t.lockable  :lock_strategy => :failed_attempts, :unlock_strategy => :both
      t.boolean   :admin,             :default => false
      t.timestamps
    end
    
    # Setup Indexes for Users table
    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :unlock_token,         :unique => true
    add_index :users, :username,             :unique => true
    add_index :users, :invitation_token
    
    create_table :profiles do |t|
      t.references :user
      t.string  :first_name
      t.string :last_name
      t.date  :birth_date
      t.integer :avatar_id
      t.text :about
      t.timestamps
    end
    
    create_table :groups do |t|
      t.string :title
      t.integer :avatar_id
      t.references :profile
      t.references :groupable, :polymorphic => true
      t.timestamps
    end
    
    create_table :friendships do |t|
      t.integer :inviter_id
      t.integer :invited_id
      t.string :status
      t.timestamps
    end
    
    create_table :memberships do |t|
      t.integer :group_id
      t.integer :profile_id
      t.boolean :admin
      t.timestamps
    end
    
    create_table :likes do |t|
      t.integer :user_id
      t.references :likable, :polymorphic => true
      t.timestamps
    end
    
    add_index :likes, :likable_id
    add_index :likes, :likable_type
    
    create_table :photos do |t|
      t.boolean :is_primary
      t.string :asset
      t.references :photoable, :polymorphic => true
      t.references :profile_id
      t.timestamps
    end
    
    add_index :photos, :photoable_id
    add_index :photos, :photoable_type
    
    create_table :comments do |t|
      t.text :comment
      t.references :commentable, :polymorphic => true
      t.references :profile
      t.string :role, :default => "comments"
      t.timestamps
    end
    
    add_index :comments, :commentable_type
    add_index :comments, :commentable_id
    add_index :comments, :profile_id
    
    create_table :accesses do |t|
      t.integer :group_id
      t.references :accessible, :polymorphic => true
      t.timestamps
    end
    
    add_index :accesses, :group_id
    add_index :accesses, :accessible_id
    add_index :accesses, :accessible_type
    
    create_table :albums do |t|
      t.string :name
      t.string :description
      t.references :profile
      t.timestamps
    end
    
    create_table :sessions do |t|
      t.string :session_id, :null => false
      t.text :data
      t.timestamps
    end

    add_index :sessions, :session_id
    add_index :sessions, :updated_at
    
    # Create Default User
    profile = Profile.new
    profile.first_name = 'System'
    profile.last_name = 'Administrator'
    profile.birth_date = Time.now
    User.create!(:profile => profile, :username => 'timeline', :email => 'administrator@timeline.com', :password => 'password', :password_confirmation => "password")
    
  end

  def down
    
    drop_table :users
    drop_table :profiles
    drop_table :groups
    drop_table :friendships
    drop_table :memberships
    drop_table :comments
    drop_table :likes
    drop_table :photos
    drop_table :accesses
    
  end
end
