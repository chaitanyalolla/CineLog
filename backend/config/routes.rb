Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  
  namespace :api do
  namespace :v1 do
    root 'articles#index'
    
    # Authentication routes
    post 'auth/register', to: 'authentication#register'
    post 'auth/login', to: 'authentication#login'
    
    # Movies
    resources :movies, only: [:index, :show] do
      # Nested creation only (when creating from movie page)
      resources :articles, only: [:create]
      resources :ratings, only: [:create]
    end
    
    # Articles - full CRUD at top level (for user's article management)
    resources :articles, except: [:create]  # create handled by nested route
    
    # Ratings - top level for update/destroy
    resources :ratings, only: [:update, :destroy]
  end
end
end
