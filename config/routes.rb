Rails.application.routes.draw do

  get 'static_page/home'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'issues#index'
  devise_for :users

  resources :issues, only: [:index, :show] do
    resources :dailies, only: [:index, :destroy]
  end

  resource :user_setting, only: [:show, :update]

  resource :user_home, only: [:show]
  get 'dashboard', controller: 'user_homes'

  resources :user_issues do
    collection do
      get 'chart'
    end
  end

  resources :user_investments, only: [:index, :new, :create]

  resources :investments, only: [:destroy] do
    member do
      get 'fetch'
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
