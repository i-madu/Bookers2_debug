Rails.application.routes.draw do
  get 'favorites/create'
  get 'favorites/destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  root to:"homes#top"
  get "home/about"=>"homes#about",as:"about"
  resources :users, only: [:index,:show,:edit,:update]
  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resources :book_comments, only: [:create,:destroy]
    resource :favorites,only: [:create, :destroy]
  end
  
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end