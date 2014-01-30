class SynthOligosController < ApplicationController
  require_role "stanford"
  
  # GET /synth_oligos
  def index
    @condition_array = define_conditions(params)
    if !params[:plate_string].blank? && (@condition_array.size == 0 || !@condition_array[0].include?('.plate_'))
      flash.now[:notice] = 'Plate numbers or ranges not in valid format - please try again'
      @plate_string = params[:plate_string]
      @min_date = params[:date_from]
      @max_date = params[:date_to]
      @oligo_usages = PlatePosition::OLIGO_USAGE.invert.to_a.sort.insert(0,'(All)') 
      @oligo_usage = params[:oligo_usage]
      render :action => :new_query
    else
      @synth_oligos = SynthOligo.find_all_incl_plate(@condition_array)
      render :action => :index
    end
  end

  # GET /synth_oligos/1
  def show
    @synth_oligo = SynthOligo.includes(:oligo).find(params[:id])
  end
  
  # GET /synth_oligos/1/edit
  def edit
    @synth_oligo = SynthOligo.find(params[:id])
  end

  # PUT /synth_oligos/1
  def update
    @synth_oligo = SynthOligo.find(params[:id])

    if @synth_oligo.update_attributes(params[:synth_oligo])
      flash[:notice] = 'SynthOligo was successfully updated.'
      redirect_to(@synth_oligo) 
    else
      render :action => "edit"
    end
  end
 
  #*******************************************************************************************#
  # Methods for input of parameters for retrieval of specific oligo inventory                 #
  #*******************************************************************************************#
  def new_query
    @min_date, @max_date   = PlateTube.find_min_and_max_dates
    @oligo_usages = PlatePosition::OLIGO_USAGE.invert.to_a.sort.insert(0,'(All)') 
  end
  
  #*******************************************************************************************#
  # Method for exporting oligos from 'index' view                                             #    
  #*******************************************************************************************#
  def export_oligos
    export_type = 'T1'
    @synth_oligos = SynthOligo.find_with_id_list(params[:export_id])   
    file_basename  = "synth_oligos_" + Date.today.to_s
    
    case export_type
      when 'T1'  # Export to tab-delimited text using csv_string
        @filename = file_basename + ".txt"
        csv_string = export_designs_csv(@synth_oligos)
        send_data(csv_string,
          :type => 'text/csv; charset=utf-8; header=present',
          :filename => @filename, :disposition => 'attachment')
      
      else # Use for debugging
        csv_string = export_designs_csv(@synth_oligos)
        render :text => csv_string
      end
  end
   
protected
  def define_conditions(params)
    @where_select = []
    @where_values = []
    
    @where_select, @where_values = plate_where_clause(params[:plate_string]) if !params[:plate_string].blank?
    
    if params[:oligo_usage] != '(All)'
      @where_select.push('plate_positions.oligo_usage = ?')
      @where_values.push(params[:oligo_usage])
    end
    
    db_fld = 'plate_tubes.synthesis_date'
    @where_select, @where_values = sql_conditions_for_range(@where_select, @where_values, params[:date_from], params[:date_to], db_fld)
       
    sql_where_clause = (@where_select.length == 0 ? [] : [@where_select.join(' AND ')].concat(@where_values))
    return sql_where_clause
  end
  
private  
  #*******************************************************************************************#
  # Export synthesized oligos to csv file                                                     #    
  #*******************************************************************************************#
  def export_designs_csv(synth_oligos, fmt_nr=3)
    csv_string = FasterCSV.generate(:col_sep => "\t") do |csv|
      csv << ['Date'].concat(ExportField.headings(fmt_nr))
      
      synth_oligos.each do |synth_oligo|
        fld_array = []
        
        ExportField.fld_names(fmt_nr).each do |model, fld|
          case model
            when 'synth_oligo'    then fld_array << synth_oligo.send(fld)
            when 'plate_position' then fld_array << synth_oligo.plate_position.send(fld)
            when 'plate_tube'     then fld_array << synth_oligo.plate_position.plate_tube.send(fld)
          end
        end
        
        csv << [Date.today.to_s].concat(fld_array)
      end
    end
    return csv_string
  end
  
end
