require 'active_record'

# ActsAsCommentable
module EntropiSocial
  module Acts #:nodoc:
    module Commentable #:nodoc:

      def self.included(base)
        base.extend ClassMethods  
      end
      
      module ClassMethods
        def acts_as_commentable
          has_many :comments, :as => :commentable, :dependent => :destroy
          include EntropiSocial::Acts::Commentable::InstanceMethods
          extend EntropiSocial::Acts::Commentable::SingletonMethods
          
        end
      end
      
      module InstanceMethods
        # Helper method to get the latest comments for a model
        def latest_comments
          self.comments.latest
        end
        
        # Helper that allows you to add a new comment to the model
        def add_comment(comment)
          comments << comment
        end
      end
      
      module SingletonMethods
        # Helper method to look up comments for a specific object
        # Equivalent to obj.comments
        def find_comments_for(obj)
          Comment.find_comments_for_commentable(model_commentable, obj.id)
        end
        
        # Helper method to look up comments made by a particular profile for this model
        def find_comments_for_commentable(profile)
          Comment.find_comments_for_profile(profile).for_model(model_commentable)
        end
        
        #private
          
          def model_commentable
            self.base_class.name
          end
          
      end
      
    end
  end
end

ActiveRecord::Base.send(:include, EntropiSocial::Acts::Commentable)