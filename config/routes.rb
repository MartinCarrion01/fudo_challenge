require_relative 'application'

FudoChallenge::Application.router.draw do
  post '/api/v1/auth/login', to: 'api/v1/auth#login'

  # PRODUCTS
  get '/api/v1/products', to: 'api/v1/products#index'
  get '/api/v1/products/:id', to: 'api/v1/products#show'
  post '/api/v1/products', to: 'api/v1/products#create'

  # JOBS
  get '/api/v1/jobs', to: 'api/v1/jobs#index'
  get '/api/v1/jobs/:id', to: 'api/v1/jobs#show'
end
