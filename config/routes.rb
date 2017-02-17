Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :homepage, only: 'index'

  root to: 'stats_dashboard/homepage#index'

  resources :communities
  resources :events

  namespace :stats_dashboard do
    resources :reports
  end
end
