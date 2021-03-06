Rails.application.routes.draw do

  post 'oauth/callback' => 'oauths#callback'
  get 'oauth/callback' => 'oauths#callback' # for use with Github, Facebook
  get 'oauth/:provider' => 'oauths#oauth', :as => :auth_at_provider

  get 'login' => 'user_sessions#new', as: :login
  post 'logout' => 'user_sessions#destroy', as: :logout
  get 'about' => 'pages#about', as: :about
  root to: 'pages#home'

  resources :user_sessions
  resources :users, except: [:index] do
    member do
      get :activate
      patch :default_group
    end
    collection do
      get :auto_complete
    end
  end

  # Only the collection routes of the children get member routes of the parent
  shallow do
    resources :user_groups do
      resources :groceries, except: [:update, :index, :edit] do
        resources :items, only: [:index, :update] do
          collection do
            get :auto_complete
          end
        end
        member do
          get :recipes
          get :checkout
          patch :do_checkout
          patch :update_items
          patch :update_recipes
          patch :update_store
          post :email_group
        end
      end
      member do
        get :payments
        patch :accept_invitation
        patch :do_payment
      end
    end
  end
end
