
module EntropiSocial
  module ActsAsCommentable
    # including this module into your Comment model will give you finders and named scopes
    # useful for working with Comments.
    # The named scopes are:
    #   in_order: Returns comments in the order they were created (created_at ASC).
    #   recent: Returns comments by how recently they were created (created_at DESC).
    #   limit(N): Return no more than N comments.
    module Comment

      def self.included(comment_model)
        comment_model.extend Finders
        
        comment_model.scope :in_order, comment_model.order('created_at ASC')
        comment_model.scope :recent,   comment_model.order('created_at DESC')
        comment_model.scope :by_commentable, lambda { |commentable_id| comment_model.where(:commentable_id => commentable_id) }
        comment_model.scope :for_profile, lambda { |profile| comment_model.where(:profile_id => profile.id) }
        comment_model.scope :for_model, lambda { |m| comment_model.where(:commentable_type => m) }
      end
    
      def all
        find(:all).in_order
      end

      module Finders
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