Rails.application.routes.draw do
  # Common
  resource :omniauth_registrations, only: :create
  resource :omniauth_sessions, only: :create
  post 'user_token' => 'user_token#create'

  resources :users, only: [:show, :update] do
    resources :comments, only: :index
  end

  resources :user_registrations, only: :create
  resource :user_password, only: [:create, :update]
  resource :user_confirmation, only: :create

  # Library
  resources :featured_publications, only: :index
  resources :recent_sections, only: :index
  resources :pseudonyms, only: :index

  resources :authors, only: [:index, :show, :create, :update] do
    resources :publications, only: :index
  end

  resources :publications, only: [:index, :show, :create, :update] do
    resources :sections, only: [:show, :create, :update] do
      resources :images, only: [:show, :create]
    end
  end

  resources :categories, only: [:index, :show] do
    resources :publications, only: :index
  end

  # Forum
  resources :subjects, only: [:show, :index] do
    resources :discussions, only: :index
  end

  resources :discussions, only: [:index, :show, :create, :update] do
    resources :comments, only: [:index, :create, :update]
  end
end
