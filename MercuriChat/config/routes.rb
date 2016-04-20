Rails.application.routes.draw do
  resources :users
  root 'users#index'
  get 'index'   => 'users#index', to: redirect('/')
  get 'register' => 'users#register', as: :register
  get 'index_debug' => 'users#index1', as: :index_debug
  get 'sign_in'  => 'users#sign_in', as: :'sign_in'
  get 'about'    => 'users#about', as: :about
  get 'team'     => 'users#team', as: :team
  get 'dashboard'     => 'chat#dashboard', as: :dashboard

  # Making edits for Devise:
  # devise_for :users

  # Referenced from: http://rvg.me/2013/11/adding-a-bootstrap-3-layout-to-a-rails-4-project/
  # get '/about'    => 'high_voltage/users#show', id: 'about'
  # get '/team'     => 'high_voltage/users#show', id: 'team'
  # get '/register' => 'high_voltage/users#show', id: 'register'
  # get '/sign-in'  => 'high_voltage/users#show', id: 'sign-in'

  # get '/index', to: redirect('/')
  # root :to => 'high_voltage/users#show', id: 'index'

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
