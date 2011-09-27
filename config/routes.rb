ActionController::Routing::Routes.draw do |map|
  # Home page
  map.root :controller => "oligo_designs", :action => "welcome" 
  
  # Signup/Login 
  map.signup  '/signup',           :controller => 'users',   :action => 'new' 
  map.forgot  '/forgot',           :controller => 'users',   :action => 'forgot'  
  map.reset   'reset/:reset_code', :controller => 'users',   :action => 'reset'
  map.login  '/login',  :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  
  map.resources :users
  map.resource :session
  
  # Oligo Designs
  map.resources :oligo_designs
  map.designquery 'designquery',       :controller => 'oligo_designs', :action => 'select_params'
  map.list_selected 'list_oligos',     :controller => 'oligo_designs', :action => 'list_selected'
  map.export 'export',                 :controller => 'oligo_designs', :action => 'export'
  
  # Synthesis Plates/Tubes
  map.resources :plate_tubes
  map.resources :plate_positions
  map.resources :synth_oligos
  map.plate_query 'plate_query', :controller => 'plate_tubes',  :action => 'new_query'
  map.inv_query 'inv_query',     :controller => 'synth_oligos', :action => 'new_query'
  
  # Oligo Pools
  map.resources :pools
  map.resources :aliquot_to_pools 
  map.pool_params 'pool_params',  :controller => 'pools',  :action => 'new_params'
  map.pools_list  'pools_list',   :controller => 'pools',  :action => 'list_oligos'
  
  # Error/not implemented
  map.notimplemented 'notimplemented', :controller => 'dummy',         :action => 'notimplemented'
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #map.resources :recipes, :collection => { :search => :get }
  
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
