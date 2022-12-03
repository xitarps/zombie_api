# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :survivors, only: %i[create show update]
    end
  end
end
