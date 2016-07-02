class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :collaborators
  has_many :wikis, through: :collaborators
  
  after_initialize :default_role
  
  enum role: [:standard, :admin, :premium]
  
  def default_role
    self.role ||= :standard
  end
  
  def downgrade
    self.standard!
    customer = Stripe::Customer.retrieve(self.stripe_id)
    Stripe::Subscription.retrieve(customer.subscriptions.data.first.id).delete if customer.subscriptions.data.first
    self.make_wikis_public
  end
  
  def make_wikis_public
    self.wikis.where(private: true).each do |wiki|
      wiki.update_attributes(private: false)
    end
  end
end
