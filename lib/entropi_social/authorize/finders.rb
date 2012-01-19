module EntropiSocial
  module Authorize
    module Finders
      def self.included(base)
        base.extend(ClassMethods)
        base.scope :by_profile_id, lambda { |profile_id| base.where(:profile_id => profile_id) }
        base.scope :by_membership_id, lambda { 
          |profile_id| base.joins(:accesses => [:group => :memberships]).where(:memberships =>{:user_id => profile_id})
        }
        base.scope :by_id, lambda { |base_id| base.where(:id => base_id).limit(1) }
      end
        
      module ClassMethods
        # This model determins if it will send back entities owned by a user, or viewable by a user
        def for(requesting_user, for_profile)
          requesting_user.id.eql?(for_profile.user_id) ? owned_by(for_profile) : viewable_for(for_profile)
        end
        
        # This mehtod gets all records that are owned by this particular profile
        def owned_by (profile)
          by_profile_id(profile.id)
        end

        # This method gets all the records that are viewable by a particular profile
        def viewable_for (profile)
          by_membership_id(profile.id)
        end
        
        def default_scoped?
          false
        end
      end
    end
  end
end
