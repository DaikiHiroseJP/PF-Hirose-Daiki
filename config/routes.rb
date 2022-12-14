Rails.application.routes.draw do
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
    resources :customers, only:[:show,:edit,:index,:update] do
     collection do
       get 'unsubscribe'
       patch 'withdraw'
     end
   end
   resources :items, only:[:index,:new,:create,:show,:edit,:update]
  end
end
