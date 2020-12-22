Rails.application.routes.draw do

  # resources :parcel_types, only: %i[index create]

  namespace :api, defaults: { format: :json } do
    resources :parcel_types, only: %i[index create]
    resource :parcel_type, only: %i[update]

    resources :parcels, only: %i[index]

  #   resources :products, only: %i[index show create update] do
  #     member do
  #       post :export
  #     end
  #   end
  #   get 'summary', action: :summary, controller: 'products'
  end

  # root 'products#index'
end
