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
    resource :customers, only:[:show] do
     collection do
       patch "information/update" => "customers#update", as:"update"
       get "information/edit" => "customers#edit", as:"edit"
       get 'unsubscribe'
       patch 'withdraw'
     end
    end
  end
end
