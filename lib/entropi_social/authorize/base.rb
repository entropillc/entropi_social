require 'active_record'

module EntropiSocial
  module Authorize
    module Base
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module InstanceMethods
        
        def access_groups
          group_ids = Array.new
          self.accesses.each { |access| group_ids.push(access.group_id) }
          return group_ids
        end
        
        def set_access_groups(group_id_array)
          # remove existing values no included in the group_id_array
          self.accesses.each { |access| access.destroy unless group_id_array.include?(access.id) }
          group_id_array.each { |group_id| give_access_to_group(group_id) }
        end
        
        def give_access_to_group(group_id)
          self.accesses.build(:group_id => group_id) unless self.accesses.exists?(:group_id => group_id)
        end
        
        def remove_access_from_group(group_id)
          self.accesses.where(:group_id => group_id).each { |access| access.destroy }
        end
        
      end  
        
        
      module ClassMethods
      
        def acts_as_authorizable
          include EntropiSocial::Authorize::Base::InstanceMethods
          include EntropiSocial::Authorize::Finders
          has_many :accesses, :as => :accessible
          belongs_to :profile
          
          #before_save :set_access_permissions
          
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, EntropiSocial::Authorize::Base)