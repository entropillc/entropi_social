require 'active_record'

module EntropiSocial
  module Authorize
    module Base
      def self.included(base)
        base.extend(ClassMethods)
      end
        
      module ClassMethods
      
        def acts_as_authorizable
          include EntropiSocial::Authorize::Finders
          has_many :accesses, :as => :accessible
          belongs_to :profile
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, EntropiSocial::Authorize::Base)