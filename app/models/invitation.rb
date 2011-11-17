class Invitation < ActiveRecord::Base
  
  belongs_to  :requestor,
              :class_name => "User",
              :foreign_key => "requestor_id"
  
  belongs_to  :invited,
              :class_name => "User"
              :foreign_key => "invited_id"
  
end
