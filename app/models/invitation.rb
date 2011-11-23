class Invitation < ActiveRecord::Base
  
  belongs_to  :requestor,
              :class_name => "User",
              :foreign_key => "requestor_id"
  
  belongs_to  :invited,
              :class_name => "User",
              :foreign_key => "invited_id"
              
              
  # Accept an invitation by clearing invitation token and confirming it if model
  # is confirmable
  def accept_invitation!
    if self.invited? && self.valid?
      self.invitation_token = nil
      self.invitation_accepted_at = Time.now.utc if respond_to? :"invitation_accepted_at="
      self.save(:validate => false)
    end
  end
  
  
  # Verifies whether a user has been invited or not
  def invited?
    persisted? && invitation_token.present?
  end
  
  # Reset invitation token and send invitation again
  def invite!
    was_invited = invited?
    generate_invitation_token if self.invitation_token.nil?
    self.invitation_sent_at = Time.now.utc
    if save(:validate => false)
      self.requestor.decrement_invitation_limit! if !was_invited and self.requestor.present?
      deliver_invitation
    end
  end
  
  # Verify whether a invitation is active or not. If the user has been
  # invited, we need to calculate if the invitation time has not expired
  # for this user, in other words, if the invitation is still valid.
  def valid_invitation?
   invited? && invitation_period_valid?
  end
  
  class << self
    def generate_token
      alphanumerics = ('a'..'z').to_a.concat(('A'..'Z').to_a.concat(('0'..'9').to_a))
      self.token = alphanumerics.sort_by{rand}.to_s[0..10]
      # Ensure uniqueness of the token..
      generate_token unless Invitation.find_by_token(self.token).nil?
    end
    
  end
  
  protected
  
    # Deliver the invitation email
    def deliver_invitation
      # TODO: Needs Implemented
    end

    # Checks if the invitation for the user is within the limit time.
    # We do this by calculating if the difference between today and the
    # invitation sent date does not exceed the invite for time configured.
    # Invite_for is a model configuration, must always be an integer value.
    #
    # Example:
    #
    #   # invite_for = 1.day and invitation_sent_at = today
    #   invitation_period_valid?   # returns true
    #
    #   # invite_for = 5.days and invitation_sent_at = 4.days.ago
    #   invitation_period_valid?   # returns true
    #
    #   # invite_for = 5.days and invitation_sent_at = 5.days.ago
    #   invitation_period_valid?   # returns false
    #
    #   # invite_for = nil
    #   invitation_period_valid?   # will always return true
    #
    def invitation_period_valid?
      sent_at && (self.class.invite_for.to_i.zero? || sent_at.utc >= self.class.invite_for.ago)
    end

    # Generates a new random token for invitation, and stores the time
    # this token is being generated
    def generate_invitation_token
      self.invitation_token   = self.class.generate_token 
    end

end
