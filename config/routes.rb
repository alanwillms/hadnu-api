Rails.application.routes.draw do
  # Options requests
  match '*path', via: [:options], to: lambda { |_|
    [
      204,
      {
        'Content-Type' => 'text/plain',
        'Access-Control-Allow-Origin' => '*',
        'Access-Control-Request-Method' => '*',
        'Access-Control-Allow-Headers' => 'Authorization, Content-Type, X-Total, X-Per-Page, X-Page',
        'Access-Control-Expose-Headers' => 'Authorization, Content-Type, X-Total, X-Per-Page, X-Page'
      },
      []
    ]
  }

  # Authentication
  post 'auth/:provider/callback' => 'omniauth#create'
  post 'user_token' => 'user_token#create'

  # Regular routes
  resources :users, only: :show

  resources :authors, only: :index do
    resource :photo, only: :show
  end

  resources :publications, only: :index do
    resource :banner, only: :show
    resource :pdf, only: :show
  end

  resources :categories, only: [:index, :show] do
    resource :banner, only: :show
    resources :publications, only: :index
  end

  resources :subjects, only: [:show, :index] do
    resources :discussions, only: :index
  end

  resources :discussions, only: [:index, :show, :create] do
    resources :comments, only: [:index, :create]
  end
end
