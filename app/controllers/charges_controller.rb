class ChargesController < ApplicationController
    
def create
    customer = Stripe::Customer.create(
        email: current_user.email,
        card: params[:stripeToken],
        plan: 'premium'
    )

    current_user.premium!
    current_user.update_attribute(:stripe_id, customer.id)
    
    flash[:notice] = "Thanks for subscribing, #{current_user.email}!"
    redirect_to wikis_path(current_user)

    rescue Stripe::CardError => e
        flash[:alert] = e.message
        redirect_to new_charge_path
end

def unsubscribe
    customer = Stripe::Customer.retrieve(current_user.stripe_id)
  
    
    Stripe::Subscription.retrieve(customer.subscriptions.data.first.id).delete if customer.subscriptions.data.first
    
    current_user.standard!
    
    flash[:alert] = "Sorry to see you go, #{current_user.email}! Please come back again."
    redirect_to wikis_path(current_user)
end


def new
    @stripe_btn_data = {
     key: "#{ Rails.configuration.stripe[:publishable_key] }",
     description: "Premium Membership - #{current_user.email}",
     amount: 1500
    }
end

end
