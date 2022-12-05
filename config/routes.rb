# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :survivors, only: %i[create show update] do
        member do
          get 'retrive_closest_survivor'
        end
      end
      resources :infections, only: %i[create]
    end
  end
end
