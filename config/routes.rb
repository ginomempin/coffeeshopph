Rails.application.routes.draw do

  root      'static_pages#home'

  # Static Pages
  get       '/home'     => 'static_pages#home'
  get       '/help'     => 'static_pages#help'
  get       '/about'    => 'static_pages#about'
  get       '/contact'  => 'static_pages#contact'

  # Sessions (Login, Logout, Authentication)
  get       '/login'    => 'sessions#new'
  post      '/login'    => 'sessions#create'
  delete    '/logout'   => 'sessions#destroy'

  # Users (Signup, Profile)
  get       '/signup'   => 'users#new'
  resources :users

end
