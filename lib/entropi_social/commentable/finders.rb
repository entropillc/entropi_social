
module EntropiSocial
  module Commentable
    # This is included in the comment model and provides usefile methods for finding information
    # The named scopes are:
    #   in_order: Returns comments in the order they were created (created_at ASC).
    #   recent: Returns comments by how recently they were created (created_at DESC).
    #   by_commentable: Returns all the records with a certain commentable_id
    #   for_profile: Returns all the records for a given profile
    #   for_model: Return all the records for a given model
    module Finders

      def self.included(comment_model)
        comment_model.extend Finders
      end
    
      def all
        find(:all).in_order
      end

      module Finders
        
        # Orders comments ascending by by the date created
        def in_order
          self.order('created_at ASC')
        end
        
        # Orders comments descending by the date created
        def recent
          self.order('created_at DESC')
        end
        
        # Finds comments that belong to a specifics model id (commentable_id)
        # This is usually used in conjunction with for_model. For example you wold
        # Find all comments for Entry for_model('Entry') where the entry id is 1
        #   Comment.for_model('Entry').by_commentable(1)
        # This finds all comments for the Entry with an id of 1.
        def by_commentable(commentable_id)
          self.where(:commentable_id => commentable_id)
        end
        
        # Finds all comments for a profile
        def for_profile(profile)
          self.where(:profile_id => profile.id)
        end
        
        # Finds all comments for a particular model
        def for_model(m)
          self.where(:commentable_type => m)
        end
        
        # Helper class method to lookup all comments assigned
        # to all commentable types for a given user.
        def find_comments_for_profile(profile)
          self.for_profile(profile).recent
        end

        # Helper class method to look up all comments for 
        # commentable class name and commentable id.
        def find_comments_for_commentable(commentable_str, commentable_id)
          self.for_model(commentable_str).by_commentable(commentable_id).recent
        end

        # Helper class method to look up a commentable object
        # given the commentable class name and id 
        def find_commentable(commentable_str, commentable_id)
          model = commentable_str.constantize
          model.respond_to?(:find_comments_for) ? model.find(commentable_id) : nil
        end
      end
    end
  end
end