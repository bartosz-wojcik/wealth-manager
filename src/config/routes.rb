Rails.application.routes.draw do
  get 'signup' => 'sessions#new', as: :signup
  post 'signup' => 'sessions#save', as: :signup_save
  get 'login' => 'sessions#create', as: :login
  get 'logout' => 'sessions#destroy', as: :logout
  post 'login' => 'sessions#create'

  get 'accounts/details'
  patch 'accounts/details'
  get 'accounts/password'
  patch 'accounts/password'
  post 'accounts/password'
  get 'accounts/resend_activation'

  # account activation urls
  get 'activate' => 'sessions#activate_start', as: :activate_start
  post 'activate' => 'sessions#activate_start', as: :activate_start_post
  get 'activate/:key' => 'sessions#activate', as: :activate

  # password recovery urls
  get 'recover' => 'sessions#recover_start', as: :recover_start
  post 'recover' => 'sessions#recover_start', as: :recover_start_post
  get 'recover/:key' => 'sessions#recover', as: :recover

  root 'site#index'
end
