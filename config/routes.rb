# frozen_string_literal: true

Rails.application.routes.draw do
  root 'jobs#index'
  resources :jobs
  resources :job_searches, only: :new
end
