Rails.application.routes.draw do
  resources :categories, only: [:index, :create]
  delete 'categories', action: :destroy, controller: 'categories', as: 'category'
  
  resources :category_threads, path: 'thread', only: [:create, :index] do
    collection do
      resources :posts, path: 'post', controller: 'thread_posts', only: [:create, :index]
    end
  end

  resource :category_threads, path: 'thread', only: [:destroy], param: :id
  
  post 'user/register', action: :register, controller: 'users', as: 'register'
  post 'user/login', action: :login, controller: 'users', as: 'login'
  post 'csv', action: :import, controller: 'users', as: 'import'
   
  get 'search', action: :search, controller: 'thread_posts', as: 'search'


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
