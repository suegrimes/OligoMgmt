class PlateTubesController < ApplicationController
  require_role "stanford"
  
  def new_query
    @min_plate, @max_plate = PlateTube.find_min_and_max_plates
    @min_date, @max_date   = PlateTube.find_min_and_max_dates
  end
  
  # GET /plate_tubes
  # GET /plate_tubes.xml
  def index
    sql_where_clause = define_conditions(params)
    @plate_tubes = PlateTube.find_all_incl_oligos(sql_where_clause)
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
  def define_conditions(params)
    @where_select = []
    @where_values = []
    
    db_fld = 'CAST(SUBSTRING(plate_tubes.plate_number,2,2) AS UNSIGNED)'
    @where_select, @where_values = sql_conditions_for_range(@where_select, @where_values, params[:plate_from], params[:plate_to], db_fld)
    
    db_fld = 'plate_tubes.synthesis_date'
    @where_select, @where_values = sql_conditions_for_range(@where_select, @where_values, params[:date_from], params[:date_to], db_fld)
       
    sql_where_clause = (@where_select.length == 0 ? [] : [@where_select.join(' AND ')].concat(@where_values))
    return sql_where_clause
  end
  
end
