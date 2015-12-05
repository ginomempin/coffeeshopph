Rails.application.routes.draw do

  root      'static_pages#home'

  # Static Pages
  get       '/home'     => 'static_pages#home'
  get       '/help'     => 'static_pages#help'
  get       '/about'    => 'static_pages#about'
  get       '/contact'  => 'static_pages#contact'

  # Sessions (Login, Logout)
  get       '/login'    => 'sessions#new'
  post      '/login'    => 'sessions#create'
  delete    '/logout'   => 'sessions#destroy'

  # Users
  get       '/signup'   => 'users#new'
  resources :users

  # Account Activations
  resources :account_activations, only: [:edit]

  # Password Resets
  resources :password_resets,     only: [:new, :create, :edit, :update]

  # Tables
  resources :tables

  # Orders
  resources :orders,              only: [:index, :show, :create, :destroy]

  # Customers
  resources :customers,           only: [:create, :destroy]

  # API
  # These resource endpoints are automatically mapped by Rails
  # to a directory under app/controllers with the same name
  # as the defined namespace.
  namespace :api, defaults:    { format: :json },
                  constraints: { subdomain: 'api' },
                  path:        '/' do

  end

end
