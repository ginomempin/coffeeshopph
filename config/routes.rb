Rails.application.routes.draw do

  ###########
  # API     #
  ###########
  # (1) These resource endpoints are automatically mapped by Rails
  #     to a directory under app/controllers with the same name
  #     as the defined namespace and the scoped module version.
  #     Ex. <namespace>/<version>/tables_controller
  #
  # (2) It is important that API routes are listed first so that
  #     they will be prioritized before the HTML routes.
  #
  # (3) To access the API route:
  #      with 'api' as subdomain:
  #           production:  api.<base URL>/<resource>
  #           development: api.lvh.me:<port>/<resource>
  #      with 'api' in path:
  #           production:  <base URL>/api/<resource>
  #           development: localhost:<port>/api/<resource>

  namespace :api, defaults:    { format: :json },
                  # constraints: { subdomain: 'api' },
                  path:        '/api' do
    scope module: :v1,
          constraints: Constraints::API.new(version: 1, default: true) do
      resources :users,  only: [:show]
      resources :tables, only: [:show]
      resources :orders, only: [:create]
    end
  end

  ###########
  # HTML    #
  ###########

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

  ###########
  # DEFAULT #
  ###########

  root      'static_pages#home'

end
