Rails.application.routes.draw do
  get  'signup' => 'sessions#new', as: :signup
  post 'signup' => 'sessions#save', as: :signup_save
  get  'login' => 'sessions#create', as: :login
  post 'login' => 'sessions#create_post'
  get  'logout' => 'sessions#destroy', as: :logout

  get   'accounts/details'
  match 'accounts/details_post', via: [:post, :patch]
  match 'accounts/password_post', via: [:post, :patch]
  match 'accounts/notifications_post', via: [:post, :patch]
  get   'accounts/resend_activation'

  # account activation urls
  get  'activate' => 'sessions#activate_start', as: :activate_start
  post 'activate' => 'sessions#activate_start_post', as: :activate_start_post
  get  'activate/:key' => 'sessions#activate', as: :activate

  # password recovery urls
  get  'recover' => 'sessions#recover_start', as: :recover_start
  post 'recover' => 'sessions#recover_start_post', as: :recover_start_post
  get  'recover/:key' => 'sessions#recover', as: :recover

  resources :portfolios
  resources :asset_categories

  root 'site#index'
end
