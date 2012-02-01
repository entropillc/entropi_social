class EntropiSocial::Profile < ActiveRecord::Base
  belongs_to :user
  
  has_many :friendships_by_others, :class_name => "Friendship", :foreign_key => 'invited_id', :conditions => "status = '#{Friendship::ACCEPTED}'"
  has_many :friendships_by_me, :class_name => "Friendship", :foreign_key => 'inviter_id', :conditions => "status = '#{Friendship::ACCEPTED}'"

  has_many :follower_friendships, :class_name => "Friendship", :foreign_key => "invited_id", :conditions => "status = '#{Friendship::PENDING}'"
  has_many :following_friendships, :class_name => "Friendship", :foreign_key => "inviter_id", :conditions => "status = '#{Friendship::PENDING}'"

  has_many :friends_by_others,  :through => :friendships_by_others, :source => :inviter
  has_many :friends_by_me, :through => :friendships_by_me, :source => :invited

  has_many :followers, :through => :follower_friendships, :source => :inviter
  has_many :followings, :through => :following_friendships, :source => :invited
  
  has_many :albums
  
  has_one :photo, :as => :photoable
  has_many :groups, :as => :groupable
  
  validates_presence_of :first_name, :last_name, :birth_date
  accepts_nested_attributes_for :photo
  
  def full_name
    first_name + " " + last_name
  end
  
  
  def self.search(query, search_options={})
    q = "%#{query}%"
    
    Profile.joins(:user).where("profiles.first_name like ? or profiles.last_name like ? or users.email like ? or users.username = ?", q, q, q, q)
  end

  def network
    friends + followings
  end

  def friends
    (friends_by_others(true) + friends_by_me(true)).uniq
  end

  def friendships
    (friendships_by_others(true) + friendships_by_me(true)).uniq
  end

  def full_name
     first_name.blank? && last_name.blank? ? self.user.login : "#{first_name} #{last_name}".strip
  end

  def followed_by? profile
    followers(true).include?(profile) || is_friend_of?(profile)
  end

  def follows? profile
    followings(true).include?(profile) || is_friend_of?(profile)
  end

  def is_friend_of? profile
    friends.include?(profile)
  end

  def is_related_to? profile
    me.followed_by?(profile) || me.follows?(profile) || me.is_friend_of?(profile)
  end

  def add_follower(follower)
    if follower.follows? me
      return false
    elsif me.follows? follower
      return add_friend(follower)
    else
      return Friendship.add_follower(follower, me)
    end
  end

  def add_following(following)
    following.add_follower(me)
  end

  def add_friend(friend)
    return false if friend.is_friend_of? me

    relationship = if friend.follows? me
      find_friendship(friend, me, Friendship::PENDING)
    elsif friend.followed_by? me
      find_friendship(me, friend, Friendship::PENDING)
    else
      Friendship.create(:inviter => friend, :invited => me, :status => Friendship::PENDING)
    end
    relationship.accept!
    # TODO: Need to loook at implementing a mailer
    return true
  end

  def remove_friend(friend)
    relationships = me.friendships.select{|f| f.inviter == friend  || f.invited == friend }
    destroy_relationships(relationships)
  end

  def remove_follower(friend)
    friends = is_friend_of? friend
    relationships = me.follower_friendships.select{|f| f.inviter == friend}
    destroy_relationships(relationships)
    if friends
      remove_friend(friend)
      add_following(friend)
    end
  end

  def remove_following(friend)
    friend.remove_follower(me)
  end

  private
  def destroy_relationships(relationships)
    # todo maybe we need to save this somewhere to keep historical records?
    relationships.each{|r| r.destroy}
  end

  # Freud will be happy.
  def me
    self
  end

  def find_friendship(inviter, invited, status)
     conditions = {:inviter_id => inviter.id, :invited_id => invited.id}
     conditions.merge!(:status => status) if status
     Friendship.find(:first, :conditions => conditions)
  end

  def set_default_icon
    # TODO: Need to implement
  end
end

