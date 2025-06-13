Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'login', to: 'authenticate#login'
      post 'verify-otp', to: 'authenticate#verify_otp'
      post 'resend-otp', to: 'authenticate#resend_otp'
      resources :users
      resources :accounts
      resources :transactions do
        member do
          get 'download_receipt'
        end
      end
    end
  end

# Add a catch-all route to handle routing on the frontend
  get '*path', to: 'application#index', via: :all
end
