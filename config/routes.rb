Rails.application.routes.draw do
  root "articles#index"

  get "/@:username", to: "profiles#show", as: :profile
  get "/@:username/edit", to: "profiles#edit", as: :edit_profile
  patch "/@:username", to: "profiles#update"

  resources :articles, expect: [ :show, :edit ]

  get "/@:username/:slug", to: "articles#show", as: :user_article
  get "/@:username/:slug/edit", to: "articles#edit", as: :user_edit_article
  get "/@:username/:slug/cancel", to: "articles#destroy", as: :user_destroy_article
  patch "/@:username/:slug/vote", to: "articles#vote", as: :user_article_vote

  resources :users, only: [ :new, :create ]

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  get "up" => "rails/health#show", as: :rails_health_check
end
