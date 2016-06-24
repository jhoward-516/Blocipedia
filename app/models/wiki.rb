class Wiki < ActiveRecord::Base
  belongs_to :user
  
  scope :visible_to, -> (user) { current_user.premium ? all : where(private: false) }
end
