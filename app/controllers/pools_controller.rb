class PoolsController < ApplicationController
  require_role "stanford"
  
  def new_params
    @min_date, @max_date   = PlateTube.find_min_and_max_dates
    # Invert hash keys/values (ie hash value first, then key); convert to array, sort and add blank first value
    @oligo_usages = SynthOligo::OLIGO_USAGE.invert.to_a.sort.insert(0,'') 
    @pool_types   = Pool.pool_types
  end
  
  def list_oligos
    sql_where_clause = define_conditions(params)
    @synth_oligos = SynthOligo.find(:all, :include => {:plate_position => :plate_tube}, :conditions => sql_where_clause)
    @checked = false
    @pool = Pool.new
    @storage_locations = StorageLocation.find(:all, :order => "room_nr, shelf_nr")
    render :action => 'list_oligos'
  end
  
  # GET /pools
  # GET /pools.xml
  def index
    #sql_where_clause = define_conditions(params)
    @pools = Pool.find(:all) 
    render :action => 'index'
  end

  # GET /pools/1
  # GET /pools/1.xml
  def show
    @pool = Pool.find(params[:id], :include => {:aliquot_to_pools => :plate_position})
    render :action => 'show'
  end

  # GET /pools/1/edit
  def edit
    @pool = Pool.find(params[:id])
    @storage_locations = StorageLocation.find(:all, :order => "room_nr, shelf_nr")
  end

  # POST /pools
  # POST /pools.xml
  def create
    @pool = Pool.new(params[:pool])
    if params[:plate_position_id]
      params[:plate_position_id].keys.each {|p_id| @pool.aliquot_to_pools.build(:plate_position_id => p_id)}
    end
    
    if @pool.save
      flash[:notice] = "Pool successfully created with #{params[:plate_position_id].size} plate positions/tubes"
      redirect_to(@pool)
    else
      # Validation error in entering misc pool
      @synth_oligos = SynthOligo.find(:all, :include => :plate_position, :conditions => ["id in (?)", params[:plate_position].keys])
      @checked = true
      @storage_locations = StorageLocation.find(:all, :order => "room_nr, shelf_nr")
      render :action => :list_oligos
    end
  end

  # PUT /pools/1
  # PUT /pools/1.xml
  def update
    @pool = Pool.find(params[:id])

    if @pool.update_attributes(params[:pool])
      flash[:notice] = 'Pool was successfully updated.'
      redirect_to(@pool)
    else
      render :action => "edit"
    end
  end

  # DELETE /pools/1
  # DELETE /pools/1.xml
  def destroy
    @pool = Pool.find(params[:id])
    @pool.destroy

    redirect_to(pools_url)
  end
  
protected
  def define_conditions(params)
    @where_select = []
    @where_values = []
    
    @where_select, @where_values = plate_where_clause(params[:plate_string]) if !params[:plate_string].blank?
    
    if params[:oligo_usage] && !params[:oligo_usage].blank?
      @where_select.push('oligo_usage = ?')
      @where_values.push(params[:oligo_usage])
    end   
    
    db_fld = 'plate_tubes.synthesis_date'
    @where_select, @where_values = sql_conditions_for_range(@where_select, @where_values, params[:date_from], params[:date_to], db_fld)
       
    sql_where_clause = (@where_select.length == 0 ? [] : [@where_select.join(' AND ')].concat(@where_values))
    return sql_where_clause
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
