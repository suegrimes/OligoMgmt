# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  # You can move this into a different controller, if you wish.  This module gives you the require_role helpers, and others.
  include RoleRequirementSystem
  include OligoExtensions

  before_filter :login_required
  
  require 'fastercsv'
  require 'calendar_date_select'
  
  helper :all # include all helpers, all the time
  
  # Structure used for converting array into class with label/value pairs, for collection_select
  LabelValue = Struct.new(:label, :value)
 
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '01ace71a5cf310fe9f1ee1867cd1da7b'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password
  
  def store_comment(model_instance, params)
    comment = Comment.create(:user_id => current_user.id, 
                             :title => params[:title], 
                             :comment => params[:comment])
    model_instance.add_comment(comment) 
  end

  def create_array_from_text_area(text, ret_type='text')
    if text.blank? 
      return []
    else
      param_list = (text.gsub(',', ' ')).split
      param_list.pop if param_list.last =~ /^\s*$/
    end  
    
    param_list.collect! { |value| value.to_i} if ret_type == 'integer'
    return param_list
  end
  
  def wrap_long_string(text,max_width = 60)
   (text.length < max_width) ?
    text :
    text.scan(/.{1,#{max_width}}/).join("<br>")
  end
  
   def check_if_blank(model_object, model_text, param_type)
    if model_object.nil? || model_object.empty?
      error_found = true
      flash[:notice] = "No #{model_text} found for #{param_type} entered - please try again"
    else
      error_found = false
    end
    
    return error_found
  end
  

end
