class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  before_action :set_stripe_btn, if: :devise_controller?
  
  def after_sign_in_path_for(resource)
    wikis_path
  end
  
 def set_stripe_btn 
    if current_user
    @stripe_btn_data = {
     key: "#{ Rails.configuration.stripe[:publishable_key] }",
     description: "Premium Membership - #{current_user.email}",
     amount: 1500
    }
    end
 end
end
