Rails.application.routes.draw do
  namespace :public do
    get 'relationships/followings'
    get 'relationships/followers'
  end
  devise_for :customers, controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}
  devise_for :admin, controllers: {
  sessions: "admin/sessions"
}
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "homes#top"
  get "home/about"=>"homes#about"



  #public
  scope module: :public do
    get "search" => "searches#search"
    get "search_item" => "items#search_item"
    resources :customers, only:[:show,:edit,:index,:update] do
      resource :relationships, only: [:create, :destroy]
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'
      get 'search' => 'customers#search'
     collection do
       get 'unsubscribe'
       patch 'withdraw'
     end
   end
   resources :items, only:[:index,:new,:create,:show,:edit,:update] do
    resources :book_comments, only: [:create, :destroy]
    resource :favorite, only: [:create, :destroy]
    end
  end
end
