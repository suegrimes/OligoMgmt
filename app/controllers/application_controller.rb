class ApplicationController < ActionController::Base
  protect_from_forgery
  include AuthenticatedSystem
  include RoleRequirementSystem
  include OligoExtensions

  before_filter :login_required
  
  require 'csv'

  helper :all # include all helpers, all the time
  
  # Structure used for converting array into class with label/value pairs, for collection_select
  LabelValue = Struct.new(:label, :value)
 
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '01ace71a5cf310fe9f1ee1867cd1da7b'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  #filter_parameter_logging :password
  
  def store_comment(model_instance, params)
    comment = Comment.create(:user_id => current_user.id, 
                             :title => params[:title], 
                             :comment => params[:comment])
    model_instance.add_comment(comment) 
  end

  def param_blank?(val)
    if val.nil?
      val_blank = true
    elsif val.is_a? Array
      val_blank = (val.length == 1 && val[0].blank? ? true : false )
    else
       val_blank = val.blank?
    end
    return val_blank 
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
  
  def plate_array_from_list(plate_string)
    all_plate_numbers = plate_string.split(",")
    plate_numbers = []; plate_or_tube_names = []; error = [];
    
    for num in all_plate_numbers
      num = num.to_s.delete(' ')
      
      case num
        when /^([M|T]\d+)$/ # has 'M' or 'T' followed by digits
          plate_or_tube_names << num # gather into array
          
        when /^([M|T]\d+)\-([M|T]\d+)$/ # is a range with 'M' or 'T' followed by digits
          range_begin = $1; range_end = $2;
          if range_begin[0].chr != range_end[0].chr then error << 'First letters of range ' + $1 + '-' + $2 + ' do not match'; next; end
            
          range_char = range_begin[0].chr
          min_range = range_begin[1..-1].to_i; max_range = range_end[1..-1].to_i
          if min_range > max_range then error << 'Beginning of range: ' + $1 + ' > end of range: ' + $2; next; end
            
          for i in (min_range..max_range) do
            plate_or_tube_names << [range_char, i.to_s].join
          end
          
        when /^([0|1]\d+)_(\d+).*$/ # full old format plate number: yymmdd_nnnnnx 
          plate_numbers << $2.to_i
            
        when /^\d+$/ # has digits only
          plate_numbers << num.to_i # gather into array 
          
        when /^(\d+)\-(\d+)$/ # has range of digits
          min_range = $1.to_i; max_range = $2.to_i
          if min_range > max_range then error << 'Beginning of range: ' + $1 + ' > end of range: ' + $2; next; end
          
          for i in (min_range..max_range) do
            plate_numbers << i
          end
          
        else error << num + ' is unexpected value'
      end # case
    end # for
    return plate_or_tube_names, plate_numbers
  end
  
  def plate_where_clause(plate_string)
    where_select = []; where_values = [];
    plate_or_tube_names, plate_numbers = plate_array_from_list(plate_string)
    
    if (!plate_or_tube_names.empty?) 
      where_select.push("(plate_tubes.plate_or_tube_name IN (?))")
      where_values.push(plate_or_tube_names)
    end
    
    if (!plate_numbers.empty?)
      where_select.push("(LEFT(plate_tubes.plate_or_tube_name,1) IN (?) AND plate_tubes.plate_number IN (?))")
      where_values.push(PlateTube::PROD_PLATE_CHARS)
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
    elsif pool_string.blank?
      where_select.push('LEFT(tube_label,2) = ?')
      where_values.push(pool_type)
    end
    
    where_clause = (where_select.size > 0 ? ['(' + where_select.join(' OR ') + ')'] : [])
    #puts error if !error.empty?
    return where_clause, where_values
  end
  
  def sql_conditions_for_range(where_select, where_values, from_fld, to_fld, db_fld, nullok=false)
    datenull_or = (nullok == true ? "#{db_fld} IS NULL OR " : "")

    if !from_fld.blank? && !to_fld.blank?
      where_select.push "(#{datenull_or} #{db_fld} BETWEEN ? AND ?)"
      where_values.push(from_fld, to_fld) 
    elsif !from_fld.blank? # To field is null or blank
      where_select.push("#{datenull_or} #{db_fld} >= ?")
      where_values.push(from_fld)
    elsif !to_fld.blank? # From field is null or blank
      where_select.push("(#{db_fld} IS NULL OR #{db_fld} <= ?)")
      where_values.push(to_fld)
    end  
    return where_select, where_values 
  end
end
