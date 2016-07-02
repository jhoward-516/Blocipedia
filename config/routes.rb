Rails.application.routes.draw do
  
  devise_for :users
  
  resources :wikis do
    resources :collaborators, only: [:create, :destroy]
  end
  
  resources :charges, only: [:new, :create]
  
  get 'unsubscribe' => 'charges#unsubscribe'
  
  root 'welcome#index'
end
