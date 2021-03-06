Rails.application.routes.draw do
  get 'favorites/create'
  get 'favorites/destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  root to:"homes#top"
  get "home/about"=>"homes#about",as:"about"
  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end
  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resources :book_comments, only: [:create,:destroy]
    resources :reviews, only: [:create]
    resource :favorites,only: [:create, :destroy]
  end
  
  get "search" => "searches#search"
  
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end