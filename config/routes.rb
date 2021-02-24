Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :admin do
    resources :merchants, :invoices, :dashboard
  end

  resources :merchant do
    resources :invoices, :items
    resources :dashboard, only: [:index]
  end

  resources :customers, :invoice_items, :transactions
end
