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

  # Users (Signup, Index, Show, Edit, Delete)
  get       '/signup'   => 'users#new'
  resources :users

  # Account Activations
  resources :account_activations, only: [:edit]

  # Password Resets
  resources :password_resets,     only: [:new, :create, :edit, :update]

end
