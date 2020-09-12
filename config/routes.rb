Rails.application.routes.draw do
  devise_for :users
  resources :users do
    resource :relationships, only: [:create, :destroy]
    get 'follows' => 'relationships#follower', as: 'follows'
    get 'followers' => 'relationships#followed', as: 'followers'
  end
  resources :posts do
    resources :comments, only: [:create, :destroy]
    resource :likes, only: [:create, :destroy]
  end
  root 'homes#top'
  get 'ranking' => 'homes#ranking'
  get 'new' => 'homes#new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
