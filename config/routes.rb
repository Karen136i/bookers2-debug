Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  root to: 'homes#top'
  get '/users', to: 'users#index'
  get "home/about"=>"homes#about", as: "about"

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorite, only: [:create, :destroy] #resource:単数形なのは、1人のユーザーは1つの投稿に対して1回しかいいねできないようにするため
    resources :book_comments, only: [:create, :index, :show, :destroy]
  end
  resources :users, only: [:index, :show, :edit, :update, :destroy]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
