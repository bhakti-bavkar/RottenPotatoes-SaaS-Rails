Rottenpotatoes::Application.routes.draw do
  # map '/' to be a redirect to '/movies'
  root 'movies#index'
  resources :movies do
    member do
      get 'search' 
    end
  end
  
  get  'auth/:provider/callback' => 'sessions#create'
  post 'logout' => 'sessions#destroy'
  get  'auth/failure' => 'sessions#failure'
  get 'auth/twitter'#, :as => 'login'
  get 'auth/facebook'#, :as => 'login'
  get 'login' => 'sessions#login'
  
end
