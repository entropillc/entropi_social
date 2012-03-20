module EntropiSocial
  module Models
    module User
      
      def self.included(base)
        base.extend ClassMethods
      end
      
      module InstanceMethods

      end
      
      module ClassMethods
        #include EntropiSocial::Models::User::InstanceMethods
      end
      

      
    end
  end
end