Rails.application.routes.draw do
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
  post 'user_token' => 'user_token#create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :discussions, only: :index
end
