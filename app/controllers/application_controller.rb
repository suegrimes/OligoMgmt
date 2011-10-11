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
  
  def check_if_blank(model_object, model_text, param_type='parameters')
    if model_object.nil? || model_object.empty?
      error_found = true
      flash[:notice] = "No #{model_text} found for #{param_type} entered - please try again"
    else
      error_found = false
    end
    
    return error_found
  end
  
  def plate_where_clause(plate_string)
    all_plate_numbers = plate_string.split(",")
    where_select = []; where_values = [];
    plate_numbers = []; plate_or_tube_names = []; error = [];

    for num in all_plate_numbers
      num = num.to_s.delete(' ')    
      case num
      when /^(M\d+)$/ # has 'M' followed by digits
        plate_or_tube_names << num # gather into array
      when /^(M\d+)\-(M\d+)$/ # is a range with 'M' followed by digits
        #if $1[0].chr != $2[0].chr then error << 'First letters of ' + $1 + ' and ' + $2 + ' do not match'; next end
        where_select.push('plate_positions.plate_or_tube_name BETWEEN ? AND ?')
        where_values.push($1, $2)
      when /^\d+$/ # has digits only
        plate_numbers << num # gather into array
      when /^(\d+)\-(\d+)$/ # has range of digits
        where_select.push("plate_tubes.plate_or_tube_name NOT LIKE 'M%' AND plate_tubes.plate_number BETWEEN ? AND ?")
        where_values.push($1, $2)
      else error << num + ' is unexpected value'
      end # case
    end # for
    
    if (!plate_or_tube_names.empty?) 
      where_select.push("plate_or_tube_name NOT LIKE 'M%' AND plate_or_tube_name IN (?)")
      where_values.push(plate_or_tube_names)
    end
    
    if (!plate_numbers.empty?)
      where_select.push('plate_number IN (?)')
      where_values.push(plate_numbers)
    end
    
    where_clause = (where_select.size > 0 ? ['(' + where_select.join(' OR ') + ')'] : [])
    #puts error if !error.empty?
    return where_clause, where_values
  end
  
  def pool_where_clause(pool_type, pool_string)
    all_pool_numbers = pool_string.split(",")
    where_select = []; where_values = [];
    pool_nums = []; error = [];

    for num in all_pool_numbers
      num = num.to_s.delete(' ')    
      case num
      when /^(\d+)$/ # digits only
        pool_nums << num.to_i  # convert to integer; gather into array
      when /^(\d+)\-(\d+)$/ # has range of digits
        where_select.push('pools.tube_label BETWEEN ? AND ?')
        where_values.push(pool_type + "%04d" % $1.to_i, pool_type + "%04d" % $2.to_i) # Convert to format XXnnnn where XX is pool prefix, nnnn is 4 digit integer
      else error << num + ' is unexpected value'
      end # case
    end # for
    
    if (!pool_nums.empty?)
      where_select.push('LEFT(tube_label,2) = ? AND CAST(SUBSTRING(tube_label,3) AS UNSIGNED) IN (?)')
      where_values.push(pool_type)
      where_values.push(pool_nums)
    end
    
    where_clause = (where_select.size > 0 ? ['(' + where_select.join(' OR ') + ')'] : [])
    #puts error if !error.empty?
    return where_clause, where_values
  end
  
  def sql_conditions_for_range(where_select, where_values, from_fld, to_fld, db_fld)
    if !from_fld.blank? && !to_fld.blank?
      where_select.push "#{db_fld} BETWEEN ? AND ?"
      where_values.push(from_fld, to_fld) 
    elsif !from_fld.blank? # To field is null or blank
      where_select.push("#{db_fld} >= ?")
      where_values.push(from_fld)
    elsif !to_fld.blank? # From field is null or blank
      where_select.push("(#{db_fld} IS NULL OR #{db_fld} <= ?)")
      where_values.push(to_fld)
    end  
    return where_select, where_values 
  end

end
