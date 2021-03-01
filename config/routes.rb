# frozen_string_literal: true

Rails.application.routes.draw do
  root 'jobs#index'
  
  resources :jobs do
    collection do
      get :delete_all
    end
  end
end
