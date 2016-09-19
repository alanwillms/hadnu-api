Rails.application.routes.draw do
  # Common
  resource :omniauth_registrations, only: :create
  resource :omniauth_sessions, only: :create
  post 'user_token' => 'user_token#create'
  resources :users, only: :show
  resources :user_registrations, only: :create
  resource :user_password, only: [:create, :update]
  resource :user_confirmation, only: :create

  # Library
  resources :featured_publications, only: :index
  resources :recent_sections, only: :index

  resources :authors, only: [:index, :show, :create] do
    resources :publications, only: :index
  end

  resources :publications, only: [:index, :show] do
    resources :sections, only: [:show] do
      resources :images, only: [:show]
    end
  end

  resources :categories, only: [:index, :show] do
    resources :publications, only: :index
  end

  # Forum
  resources :subjects, only: [:show, :index] do
    resources :discussions, only: :index
  end

  resources :discussions, only: [:index, :show, :create] do
    resources :comments, only: [:index, :create]
  end
end
