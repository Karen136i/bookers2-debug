Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  root to: 'homes#top'
  get '/users', to: 'users#index'
  get "home/about"=>"homes#about", as: "about"
  get "search", to: "searches#search" # 検索機能の実装

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    # いいね機能ぼ追加
    resource :favorite, only: [:create, :destroy] #resource:単数形なのは、1人のユーザーは1つの投稿に対して1回しかいいねできないようにするため
    # コメント機能の追加
    resources :book_comments, only: [:create, :index, :show, :destroy]
  end

  resources :users, only: [:index, :show, :edit, :update, :destroy] do
    # フォロー・フォロワー機能の追加
    member do 
        get "followings" => "relationships#followings", as: "followings"
        get "followers" => "relationships#followers", as: "followers"
    end 
        resource :relationships, only: [:create, :destroy]
  end
# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

# 相互フォロワーのユーザーページで「DMを送る」というボタンを表示させる
  resources :messages, only: [:create] #ボタンを押すとroomsがcreateされる
  resources :rooms, only: [:create, :show]  
  # roomsのshowページでmessageがcreateされる
  # roomsのshowページでmessageがcreateされる
end
