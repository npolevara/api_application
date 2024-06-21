Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :jobs, only: [:index]
      get 'applications_for_activated_jobs', to: 'jobs#applications_for_activated_jobs'
    end
  end
end
