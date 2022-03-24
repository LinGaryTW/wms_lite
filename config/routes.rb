Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get '/warehouses/:key_word' => 'warehouses#show'
  post '/warehouses' => 'warehouses#create'
  put '/warehouses/:id' => 'warehouses#update'
  delete '/warehouses/:id' => 'warehouses#destory'
end
