# frozen_string_literal: true

# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users do
        collection do
          get 'search'
        end
      end
    end
  end

  # / にアクセスしたら /api/v1/users#index にルーティング
  root to: 'api/v1/users#index'
end
