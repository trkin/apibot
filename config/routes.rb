require 'sidekiq/web'
Rails.application.routes.draw do
  shallow do
    root 'home#home'
    devise_for :users
    authenticate :user, ->(u) { u.superadmin? } do
      mount Sidekiq::Web => '/sidekiq'
    end

    get 'home/home'
    get 'sign-in-development/:id', to: 'home#sign_in_development', as: :sign_in_development
    get 'contact', to: 'home#contact'
    post 'contact', to: 'home#submit_contact'
    post 'notify-javascript-error', to: 'home#notify_javascript_error'

    get :examples, to: 'examples/application#index'
    scope :examples do
      get :paginated_with_links, to: 'examples/paginated_with_links#index'
      get 'paginated_with_links/:id', to: 'examples/paginated_with_links#book', as: :paginated_with_links_book
      get :paginated_with_errors, to: 'examples/paginated_with_errors#index'
      get 'paginated_with_errors/:id', to: 'examples/paginated_with_errors#book', as: :paginated_with_errors_book
      get :sample_error, to: 'examples/application#sample_error', as: :sample_error
      get :non_ascii, to: 'examples/non_ascii#index', as: :non_ascii
      get 'шoу', to: 'examples/non_ascii#show', as: :show_non_ascii
    end

    resource :sign_up
    resource :dashboard
    resources :bots do
      collection do
        post :search
      end
      resources :inspects do
        collection do
          post :search
        end
      end
      resources :steps do
        collection do
          post :search
        end
      end
    end
    resources :runs do
      collection do
        post :search
      end
      member do
        post :inspect_all
        post :cancel
      end
      resources :pages do
        collection do
          post :search
        end
        member do
          get :content
          post :inspect
        end
      end
    end

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
end
