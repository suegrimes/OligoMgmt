class PoolsController < ApplicationController
  require_role "stanford"
  
  def new_params
    @min_date, @max_date   = PlateTube.find_min_and_max_dates
    # Invert hash keys/values (ie hash value first, then key); convert to array, sort and add blank first value
    @oligo_usages = SynthOligo::OLIGO_USAGE.invert.to_a.sort.insert(0,'') 
    @pool_types   = Pool.pool_types
  end
  
  def list_for_pool
    @from_oligos_or_pools = (params[:pool_string].blank? ? 'oligo' : 'pool')
    
    if @from_oligos_or_pools == 'pool'
      sql_where_clause = define_pool_conditions(params)
      @current_pools = Pool.find(:all, :conditions => sql_where_clause,
                                       :order => :tube_label)
    else
      sql_where_clause = define_oligo_conditions(params)
      @plate_positions = PlatePosition.find(:all, :include => :plate_tube, :conditions => sql_where_clause,
                                                  :order => 'plate_positions.plate_or_tube_name, plate_position')
    end
    @checked = false
    @pool = Pool.new
    @storage_locations = StorageLocation.find(:all, :order => "room_nr, shelf_nr")
    render :action => 'list_for_pool'
  end
  
  # GET /pools
  # GET /pools.xml
  def index
    #sql_where_clause = define_conditions(params)
    @pools = Pool.find(:all, :order => :tube_label) 
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
      success_msg_dtls = "#{params[:plate_position_id].size} plate_positions/tubes"
      params[:plate_position_id].keys.each {|p_id| @pool.aliquot_to_pools.build(:plate_position_id => p_id)}
    elsif params[:pool_id]
      success_msg_dtls = "#{params[:pool_id].size} existing pools"
      aliquot_to_pools = AliquotToPool.find(:all, :conditions => ['pool_id IN (?)', params[:pool_id].keys])
      aliquot_to_pools.each {|aliquot| @pool.aliquot_to_pools.build(:plate_position => aliquot.plate_position)}
    end
    
    if @pool.save
      flash[:notice] = "Pool successfully created from #{success_msg_dtls}"
      redirect_to(@pool)
    else
      # Validation error in entering pool
      @synth_oligos = SynthOligo.find(:all, :include => :plate_position, :conditions => ["id in (?)", params[:plate_position].keys])
      @checked = true
      @storage_locations = StorageLocation.find(:all, :order => "room_nr, shelf_nr")
      render :action => :list_for_pool
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
    @pool = Pool.find(params[:id], :include => :aliquot_to_pools)
    @pool.destroy

    redirect_to(pools_url)
  end
  
protected
  def define_oligo_conditions(params)
    @where_select = [];  @where_values = []
    
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
  
  def define_pool_conditions(params)
    @where_select = []; @where_values = []
    
    @where_select, @where_values = pool_where_clause(params[:pool_type], params[:pool_string]) 
    
    sql_where_clause = (@where_select.length == 0 ? [] : [@where_select.join(' AND ')].concat(@where_values))
    return sql_where_clause
  end

end
