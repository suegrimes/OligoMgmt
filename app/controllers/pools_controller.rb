class PoolsController < ApplicationController
  require_role "stanford"
  
  def new_params
    @pool_types   = Pool.pool_types.insert(0,'')
  end
  
  def list_for_pool
    if !params[:pool_string].blank? && !params[:pool_type].blank?  
      sql_where_clause = define_pool_conditions(params)
      @current_pools = Pool.find(:all, :conditions => sql_where_clause,
                                       :order => :tube_label)
      if !params[:plate_string].blank?
        sql_where_clause = define_plate_conditions(params)
        @current_plates = PlateTube.find_all_plates(sql_where_clause)
      end
      
    elsif !params[:plate_string].blank?
      sql_where_clause = define_plate_conditions(params)
      @plate_positions = PlatePosition.find_all_positions(sql_where_clause)
    end
    
    if !@current_pools.nil? || !@plate_positions.nil?
      @pool = Pool.new
      @checked = false
      @storage_locations = StorageLocation.find(:all, :order => "room_nr, shelf_nr")
      render :action => 'list_for_pool'
    else
      flash.now[:notice] = 'Please enter pool type and numbers, and/or plate numbers for new pool'
      @pool_types = Pool.pool_types.insert(0,'')
      render :action => 'new_params'
    end
  end
  
  # GET /pools
  # GET /pools.xml
  def index
    sql_where_clause = ['pools.id = ?', params[:id]] if params[:id]
    @pools = Pool.find(:all, :order => :tube_label, :conditions => sql_where_clause ) 
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
    @from_pools = Pool.find(:all, :conditions => ['id in (?)', @pool.from_pools]).collect(&:tube_label) if @pool.from_pools
    @from_plates = PlateTube.find(:all, :conditions => ['id IN (?)', @pool.from_plates]).collect(&:plate_or_tube_name) if @pool.from_plates
    @storage_locations = StorageLocation.find(:all, :order => "room_nr, shelf_nr")
  end

  # POST /pools
  # POST /pools.xml
  def create
    #
    # TODO - Work on error handling.  Ideally should return to same state as submitted form, with correct boxes checked
    #
    @pool = Pool.new(params[:pool])
    @total_oligos = 0
    #render :action => 'debug'
    
    if params[:plate_position_id]  # Selecting from oligo list
      @plate_positions = PlatePosition.find(:all, :conditions => ['id IN (?)', params[:plate_position_id].keys])
      @checked_pposition_ids = params[:plate_position_id].reject {|id, val| val == '0'}.keys
      @pool.total_oligos += @checked_pposition_ids.size
      success_msg_dtls = "#{@checked_pposition_ids.size} plate_positions/tubes"
      
      # build aliquot_to_pools, only for checked plates 
      @checked_pposition_ids.each {|p_id| @pool.aliquot_to_pools.build(:plate_position_id => p_id)}    
      
    elsif params[:pool_id]         # Selecting from pools list
      @current_pools = Pool.find(:all, :include => :aliquot_to_pools, :conditions => ['id IN (?)', params[:pool_id].keys])
      @checked_pool_ids = params[:pool_id].reject {|id, val| val == '0'}.keys
      @pool.from_pools = @checked_pool_ids
      @pool.total_oligos += Pool.sum(:total_oligos, :conditions => ['id IN (?)', @checked_pool_ids])
      success_msg_dtls = "#{@checked_pool_ids.size} existing pools"

      aliquot_to_pools = AliquotToPool.find(:all, :conditions => ['pool_id IN (?)', @checked_pool_ids])
      aliquot_to_pools.each {|aliquot| @pool.aliquot_to_pools.build(:plate_position => aliquot.plate_position)}

      if params[:plate_tube_id]    # Selecting from plate/tube list
        @current_plates = PlateTube.find(:all, :conditions => ['id IN (?)', params[:plate_tube_id].keys])
        @checked_plate_ids = params[:plate_tube_id].reject {|id, val| val == '0'}.keys
        @pool.from_plates = @checked_plate_ids
        @pool.total_oligos += PlatePosition.count(:id, :conditions => ['plate_or_tube_id IN (?)', @checked_plate_ids])
        success_msg_dtls += ", #{@checked_plate_ids.size} existing plates"
        
        plate_positions = PlatePosition.find(:all, :conditions => ['plate_or_tube_id IN (?)', @checked_plate_ids])
        plate_positions.each {|plate_position| @pool.aliquot_to_pools.build(:plate_position => plate_position)}
      end
    end
    
    if @pool.save
      flash[:notice] = "Pool successfully created from #{success_msg_dtls}"
      redirect_to(@pool)
    else
      flash[:notice] = "Validation error creating pool"
      @storage_locations = StorageLocation.find(:all, :order => "room_nr, shelf_nr")
      #render :action => 'debug'
      render :action => 'list_for_pool'
    end
  end

  # PUT /pools/1
  # PUT /pools/1.xml
  def update
    @pool = Pool.find(params[:id])

    if @pool.update_attributes(params[:pool])
      flash[:notice] = 'Pool was successfully updated.'
      redirect_to(:action => :index, :id => params[:id])
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
  def define_pool_conditions(params)
    @where_select = []; @where_values = [];  
    @where_select, @where_values = pool_where_clause(params[:pool_type], params[:pool_string]) 
    sql_where_clause = (@where_select.length == 0 ? [] : [@where_select.join(' AND ')].concat(@where_values))
    return sql_where_clause
  end
  
  def define_plate_conditions(params)
    @where_select = [];  @where_values = []; 
    @where_select, @where_values = plate_where_clause(params[:plate_string]) if !params[:plate_string].blank?       
    sql_where_clause = (@where_select.length == 0 ? [] : [@where_select.join(' AND ')].concat(@where_values))
    return sql_where_clause
  end
 
end
