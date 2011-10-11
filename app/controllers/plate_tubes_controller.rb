class PlateTubesController < ApplicationController
  require_role "stanford"
  
  def new_query
    @min_date, @max_date = PlateTube.find_min_and_max_dates
    @oligo_usages = PlatePosition::OLIGO_USAGE.invert.to_a.sort.insert(0,'') 
  end
  
  # GET /plate_tubes
  # GET /plate_tubes.xml
  def index
    sql_where_clause = define_plate_conditions(params)
    @plate_tubes = PlateTube.find_all_plates(sql_where_clause)
    render :action => 'index'
  end

  # GET /plate_tubes/1
  # GET /plate_tubes/1.xml
  def show
    @plate_tube = PlateTube.find(params[:id], :include => :plate_positions)
    render :action => 'show'
  end

  # GET /plate_tubes/1/edit
  def edit
    @plate_tube = PlateTube.find(params[:id])
  end

  # POST /plate_tubes
  # POST /plate_tubes.xml
  def create
    @plate_tube = PlateTube.new(params[:plate_tube])

    if @plate_tube.save
      flash[:notice] = 'PlateTube was successfully created.'
      redirect_to(@plate_tube)
    else
      render :action => "new" 
    end
  end

  # PUT /plate_tubes/1
  # PUT /plate_tubes/1.xml
  def update
    @plate_tube = PlateTube.find(params[:id])

    if @plate_tube.update_attributes(params[:plate_tube])
      flash[:notice] = 'PlateTube was successfully updated.'
      redirect_to(@plate_tube)
    else
      render :action => "edit"
    end
  end

  # DELETE /plate_tubes/1
  # DELETE /plate_tubes/1.xml
  def destroy
    @plate_tube = PlateTube.find(params[:id])
    @plate_tube.destroy

    redirect_to(plate_tubes_url)
  end
  
protected
  def define_plate_conditions(params)
    @where_select = [];  @where_values = [];
    
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
  
end
