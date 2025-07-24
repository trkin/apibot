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
      get :sample_page, to: 'examples/sample#index'
      get :action_move_to_and_click, to: 'examples/sample#action_move_to_and_click'
      get :non_ascii, to: 'examples/sample#non_ascii', as: :non_ascii
      get 'шoу', to: 'examples/sample#show_non_ascii_in_link', as: :show_non_ascii_in_link
      get :sign_in_required, to: 'examples/sign_in_required#index'
      get :sign_in_required_login, to: 'examples/sign_in_required#login'
      post :sign_in_required_submit_login, to: 'examples/sign_in_required#submit_login'
      get :paginated_with_links, to: 'examples/paginated_with_links#index'
      get 'paginated_with_links/:id', to: 'examples/paginated_with_links#book', as: :paginated_with_links_book
      get :paginated_with_errors, to: 'examples/paginated_with_errors#index'
      get 'paginated_with_errors/:id', to: 'examples/paginated_with_errors#book', as: :paginated_with_errors_book
      get :sample_error, to: 'examples/application#sample_error'
      get :paginated_with_next_button, to: "examples/paginated_with_next_button#index"
      get "paginated_with_next_button/:id", to: "examples/paginated_with_next_button#show"
      post :paginated_with_next_button, to: "examples/paginated_with_next_button#submit"
    end

    resource :sign_up
    resource :dashboard
    resources :bots do
      member do
        post :duplicate
      end
      collection do
        post :search
      end
      resources :inspects do
        collection do
          get :calculate
          get :reorder
          post :update_position
        end
        member do
          get :duplicate
        end
      end
      resources :steps
      resources :traces do
        member do
          post :update
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

    resources :traces do
      collection do
        post :search
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
