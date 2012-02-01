module EntropiSocial
  module Authorize
    module Finders
      def self.included(base)
        base.extend(ClassMethods)
      end
        
      module ClassMethods
        
        # Finds all models owned by profile_id
        def by_profile_id(profile_id)
          self.where(:profile_id => profile_id)
        end
        
        # Finds reocrds that are vieable by a particular profile id
        def by_membership_id(id)
          self.includes(:accesses => [:group => :memberships]).where{(profile_id.eq id) | (memberships.profile_id.eq id)}
        end
        
        # Finds a model with a particular id
        def by_id(base_id)
          self.where(:id => base_id).limit(1)
        end
        
        # This model determins if it will send back entities owned by a user, or viewable by a user
        def for(requesting_user, for_profile)
          requesting_user.id.eql?(for_profile.user_id) ? self.owned_by(for_profile) : self.viewable_for(for_profile)
        end
        
        # This mehtod gets all records that are owned by this particular profile
        def owned_by (profile)
          self.by_profile_id(profile.id)
        end

        # This method gets all the records that are viewable by a particular profile
        def viewable_for (profile)
          self.by_membership_id(profile.id)
        end
        
        def default_scoped?
          false
        end
      end
    end
  end
end
