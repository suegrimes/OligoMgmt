OligoMgmt::Application.routes.draw do

  root :to => "welcome#index"
  #match '/' => 'welcome#index'
  match '/signup' => 'users#new', :as => :signup
  match '/forgot' => 'users#forgot', :as => :forgot
  match 'reset/:reset_code' => 'users#reset', :as => :reset
  match '/login' => 'sessions#new', :as => :login
  match '/logout' => 'sessions#destroy', :as => :logout
  resources :users
  resource :session
  resources :oligo_designs
  resources :pilot_oligo_designs, :only => :show
  match 'designquery' => 'oligo_designs#new_query', :as => :designquery
  match 'get_designs'   => 'oligo_designs#index', :as => :get_designs, :via => [:get]
  match 'export' => 'oligo_designs#export', :as => :export
  match 'gene_list' => 'oligo_designs#get_gene_list', :as => :gene_list
  resources :plate_tubes
  resources :plate_positions
  resources :synth_oligos
  match 'show_oligos' => 'plate_tubes#show_oligos', :as => :show_oligos
  match 'plate_query' => 'plate_tubes#new_query', :as => :plate_query
  match 'inv_query' => 'synth_oligos#new_query', :as => :inv_query
  resources :pools
  resources :aliquot_to_pools
  match 'pool_params' => 'pools#new_params', :as => :pool_params
  match 'pools_list' => 'pools#list_for_pool', :as => :pools_list
  match 'pool_query' => 'pools#new_query', :as => :pool_query
  match 'get_oligos/:id' => 'pools#get_oligos', :as => :get_oligos, :via => [:get]
  resources :storage_locations
  resources :vectors
  resources :versions
  resources :researchers
  resources :users
  match 'notimplemented' => 'dummy#notimplemented', :as => :notimplemented
  match '/:controller(/:action(/:id))'

  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
