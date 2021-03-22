Rails.application.routes.draw do

  namespace :admin do
    resources :merchants, except: [:destroy]
    resources :invoices, only: [:index, :update, :show]
    get '', to: 'dashboard#index', as: '/'
  end

  resources :merchant do
    resources :invoices, only: [:index, :show]
    resources :items, except: [:destroy]
    resources :items_status, controller: "merchant_items", only: [:update]
    resources :dashboard, only: [:index]
    resources :bulk_discounts
  end

  resources :invoice_items, only: [:update]
  root 'welcome#index'
  resources :users, only: [:create, :new]
  get '/login', to: 'users#login_form'
  post '/login', to: 'users#login'
end
