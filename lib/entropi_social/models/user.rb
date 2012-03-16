module EntropiSocial
  module Models
    module User
      
      def self.included(user_model)
        user_model.extend ClassMethods
      end
      
      module ClassMethods
        
        
      end
    end
  end
end