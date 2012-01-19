class Friendship < ActiveRecord::Base
  belongs_to :inviter, :class_name => 'Profile'
  belongs_to :invited, :class_name => 'Profile'
  
  PENDING  = "pending"
  ACCEPTED = "accepted"
  
  validates_inclusion_of :status, :in => [:accepted, :declined, :pending]
  
  
  scope :for_user, lambda { |user_id| 
    where("invitor_id = ? OR invited_id = ?", user_id, user_id)  
  }
  
  scope :by_status, lambda {|status|
    where("status = ?", status.to_s)
  }
  
  def validate
    errors.add('inviter', 'inviter and invited can not be the same user') if invited == inviter
  end

  def status
   read_attribute(:status).to_sym
  end

  def status= (value)
   write_attribute(:status, value.to_s)
  end
  
  def accept!
   self.update_attribute(:status, :accepted)
  end
  
  
  class << self
    # Create a new follower of the +inviter+ user. Returns boolean value indicating if the relationship
    # correctly created.
    #
    # ==== Options
    #
    # +inviter+  +User+ if the person that wants to be a follower if +invited+
    # 
    # +invited+  +User+ of the user followed by +inviter+
    #
    def add_follower(inviter, invited)
      # todo enable send_friendships_notifications? setting per profile
      # FriendshipMailer.deliver_new_follower(me, follower)  if me.send_friendships_notifications?
      #FriendshipMailer.deliver_new_follower(me, follower)
      a = Friendship.create(:inviter => inviter, :invited => invited, :status => :pending)
      !a.new_record?
    end
    
    # Create a friendship between the user and the target. Returns boolean value indicating if
    # the relationship was correctly created.
    #
    # ==== Options
    #
    # +user+    +User+ that purpose the friendship 
    #
    # +target+  +User+ that receives the purposement relationship 
    #
    def make_friends(user, target)
      transaction do
        begin
          find_friendship(user, target, :pending).update_attribute(:status, :accepted)
          Friendship.create!(:inviter_id => target.id, :invited_id => user.id, :status => :accepted)
        rescue Exception
          return make_friends(target, user) if user.followed_by? target
          return add_follower(user, target)
        end
      end
      true
    end
    
    # End a friendship between the user and the target. Returns a boolean indicating if the 
    # relationship was ended
    #
    # === Options
    # +user+    +User+ that wants to end the friendship
    #
    # +target+  +User+ that the friendship is being ended with
    #
    def stop_being_friends(user, target)
     transaction do
       begin
         find_friendship(target, user, ACCEPTED).update_attribute(:status, PENDING)
         find_friendship(user, target, ACCEPTED).destroy
        rescue Exception
           return false
        end
      end
      true
    end
    
    # Resets the status of a proposed friendship to pending
    #
    # === Options
    #
    # +user+    +User+ that wants reset the friendship
    #
    # +target+  +User+ for the friendship that is being reset
    #
    def reset(user, target)
      begin
        find_friendship(user, target).destroy
        find_friendship(target, user, ACCEPTED).update_attribute(:status, PENDING)
      rescue Exception
        return true
      end
      true
    end
    
    private
      # Finds a friendship by status between two users
      def find_friendship(inviter, invited, status)
         conditions = {:inviter_id => inviter.id, :invited_id => invited.id}
         conditions.merge!(:status => status) if status
         Friendship.find(:first, :conditions => conditions)
      end
    
  end
  
  private
   def profile_of(user)
     profile = case user
     when User
       user.profile
     when Profile
       user
     else
       nil
     end
   end
  
end
