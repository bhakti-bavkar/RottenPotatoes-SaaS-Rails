Rottenpotatoes::Application.routes.draw do
  # map '/' to be a redirect to '/movies'
  root 'movies#index'
  resources :movies do
    member do
      get 'search' 
    end
  end
  
end
