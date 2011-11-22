class Friendship < ActiveRecord::Base
  belongs_to :user
  
  validates_inclusion_of :status, :in => [:accepted, :declined, :pending]
  
  scope :by_user, lambda { |user_id| 
    where("invitor_id = ? OR invited_id = ?", user_id, user_id)  
  }
  
  scope :by_status, lambda {|status|
    where("status = ?", status.to_s)
  }

  def status
   read_attribute(:status).to_sym
  end

  def status= (value)
   write_attribute(:status, value.to_s)
  end

end
