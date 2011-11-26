#Schedule SQL touch every 2 hrs to avoid MySQL/Mongrel time-out issue
#(Bug in Mongrel/MySQL communication; Mongrel does not recognize that MySQL has timed out,
# and waits for MySQL response then eventually returns browser timeout error )
require 'rufus/scheduler'

if RAILS_ENV == 'production'
  scheduler = Rufus::Scheduler.start_new
  scheduler.every '2h', :first_in => '1m',
                        :tags => 'sqltouch', 
                        :try_again => false do 
    # access one record in each database, to keep SQL connection alive
    Indicator.find(:first)
    Version.find(:first)
  end
end