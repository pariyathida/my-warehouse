Rails.application.routes.draw do

  resources :products, only: %i[index new create]

  namespace :api, defaults: { format: :json } do
    resources :products, only: %i[index show create update] do
      member do
        post :export
      end
    end
    get 'summary', action: :summary, controller: 'products'
  end

  root 'products#index'
end
