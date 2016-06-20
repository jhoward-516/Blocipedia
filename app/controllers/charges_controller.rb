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
    redirect_to root_path(current_user)

    rescue Stripe::CardError => e
        flash[:alert] = e.message
        redirect_to new_charge_path
end

def destroy
    customer = Stripe::Customer.retrieve(current_user.stripe_id)
    subscription = customer.subscriptions.first
    subscription.delete
    
    current_user.standard!
end


def new
    @stripe_btn_data = {
     key: "#{ Rails.configuration.stripe[:publishable_key] }",
     description: "Premium Membership - #{current_user.email}",
     amount: 1500
    }
end

end
