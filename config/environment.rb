
# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
#RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.
  
  # Use timestamped_migrations = false, for sequential migration numbering
  # Defaults to true, for UTC timestamp migration numbering
  # Note: this statement only works in Rails versions 2.1.1 or greater
  # config.active_record.timestamped_migrations = false

  # Skip frameworks you're not going to use. To use Rails without a database
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]
  
  # When deploying using a suburi, need to specify relative root here, comment out otherwise
  # config.action_controller.relative_url_root = "/oligo_exome"

  # Specify gems that this application depends on. 
  # They can then be installed with "rake gems:install" on new installations.
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "aws-s3", :lib => "aws/s3"
  # config.gem "fastercsv", :version => '1.4.0', :source => "http://fastercsv.rubyforge.org"
    config.gem "fastercsv"
    config.gem 'calendar_date_select'
  # config.gem "tlsmail"
    
  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Comment line to use default local time.
  # config.time_zone = 'UTC'

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_OligoMgmt_session',
    :secret      => '8b7444061d4099e612c73636ae4908d36f40ab53d0365231cda1b7502743f0c7f556cce93e8f6dd8556128e9c5db06d63c8ebf64ee74bf84d8930c8c'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with "rake db:sessions:create")
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector
  config.active_record.observers = :user_observer
   
 end
 
 # Date/Time formating for CalendarDateSelect
  CalendarDateSelect.format = :iso_date

# Set MySQL connection parameters in attempt to avoid Mongrel/MySQL timeout issue
# Timeout of 604800 (mins) == one week
#ActiveRecord::Base.verification_timeout = 604800

# Should be able to remove the following two lines if using Ruby 1.8.7 or higher
# (can just use :enable_starttls_auto => true, in SMTP settings in environment/production.rb etc)
#require 'tlsmail'
#Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)