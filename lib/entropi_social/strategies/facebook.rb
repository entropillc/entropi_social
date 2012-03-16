module EntropiSocial
  module Strategies
    module Facebook
      
      def self.included(user_model)
        user_model.extend ClassMethods
      end
      
      module ClassMethods
        
        def find_for_facebook_oauth(access_token, signed_in_resource=nil)
          data = access_token.extra.raw_info
          if user = User.where(:email => data.email).first
            user
          else # Create a user with a stub password. 
            User.create!(:email => data.email, :password => Devise.friendly_token[0,20]) 
          end
        end

        def new_with_session(params, session)
          super.tap do |user|
            if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
              user.email = data["email"]
            end
          end
        end
        
      end
    end
  end
end