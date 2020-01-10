require 'sidekiq/web'
Rails.application.routes.draw do
  root 'pages#home'
  devise_for :users
  authenticate :user, ->(u) { u.superadmin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  get 'pages/home'
  get 'sign-in-development/:id', to: 'pages#sign_in_development', as: :sign_in_development
  get 'contact', to: 'pages#contact'
  post 'contact', to: 'pages#submit_contact'
  post 'notify-javascript-error', to: 'pages#notify_javascript_error'

  resource :sign_up

  resource :my_account do
    get :change_email
    get :change_password
    patch :update_password
    get :change_language
    get :edit
    patch :update
  end

  resource :my_company do
    patch :submit_choose
    delete :remove_me_from
  end
  resources :company_users do
    collection do
      post :search
    end
  end

  namespace :admin do
    resource :dashboard do
      get :sample_error
      get :sample_error_in_javascript
      get :sample_error_in_javascript_ajax
      get :sample_error_in_sidekiq
    end
    resources :users do
      collection do
        post :search
      end
    end
  end
end
