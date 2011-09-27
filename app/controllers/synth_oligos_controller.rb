class SynthOligosController < ApplicationController
  require_role "stanford"
  
  # GET /synth_oligos
  def index
    @synth_oligos = SynthOligo.find(:all)
  end

  # GET /synth_oligos/1
  def show
    @synth_oligo = SynthOligo.find(params[:id])
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
   
  end
   
  #*******************************************************************************************#
  # Method for listing oligo inventory, based on parameters entered above                     #
  #*******************************************************************************************#
  def list_inventory_debug
    render :action => 'debug'
  end
  
  def list_inventory  
    param_type = params[:param_type] ||= 'proj_gene'
    @rpt_type  = params[:rpt_type]

    # check for correct number of parameters entered
    # must have project/gene(s), or id(s)
    error_found = false
    @rc = check_params(params, param_type)
    
    # check for errors passed by parameter check, otherwise get requested oligos
    if @rc =~ /e\d/
      error_found    = true
    
    else
      @condition_array = define_conditions(params, @rc)
      @synth_oligos = SynthOligo.find_plate_wells_with_conditions(@condition_array) unless @condition_array.nil?
      error_found = check_if_blank(@synth_oligos, 'synthesized oligos', @rc)
    end
    
#    if error_found && param_type == 'proj_gene'
#      redirect_to :action => 'select_proj_genes', :project => params[:project]
#    elsif error_found
#      redirect_to :action => 'select_genes_or_ids', 
#                  :genes => params[:genes], :oligo_ids => params[:oligo_ids]
  
    if error_found
      redirect_to :action => 'select_project'
    elsif params[:rpt_type] == 'design'
      render :action => 'list_designs' 
    else
      render :action => 'list_inventory'
    end 
  end

  #*******************************************************************************************#
  # Method for export of inventory details to Excel                                           #
  #*******************************************************************************************#
  def export_inventory
    #params[:rpt_type] = 'inventory'
    @oligo_ids = params[:export_id]
    
    if params[:rpt_type] == 'inventory'
      @synth_oligos = SynthOligo.find_plate_wells_with_conditions(["synth_oligos.id IN (?)", @oligo_ids])
      @filename = "oligoinventory_" + Date.today.to_s + ".xls"
    else
      @synth_oligos = SynthOligo.find_with_id_list(@oligo_ids)
      @filename = "oligoinv_designs_" + Date.today.to_s + ".xls"
    end   
   
    headers['Content-Type']="application/vnd.ms-excel"
    headers['Content-Disposition']="attachment;filename=\"" + @filename + "\""
    
    if params[:rpt_type] == 'inventory'
      render :action => 'export_inventory', :layout => false
    else
      render :action => 'export_design', :layout => false
    end
  end

 private
  def check_params(params, param_type)
    if param_type == 'proj_gene'
      if params[:oligo_design] && params[:oligo_design][:gene_code]
        gene_list = params[:oligo_design][:gene_code]
        rc = (gene_list[0].blank? ? 'p' : 'gl')  #gene_list[0].blank? if "all genes" for project, selected
      
      elsif params[:project]
        rc = 'p'
      
      else
        flash[:notice] = 'Please select project, gene(s) or id(s)' 
        rc = 'e2'
      end
    
    else #param_type == 'gene_id'
      # when params[:genes] is too large, unpredictable browser errors occur, so trap size 
      # error before doing any other processing
      @nr_genes = params[:genes].split.size if params[:genes]
    
      if (@nr_genes && @nr_genes > 400)
        params[:genes] = []  #reset params[:genes] to avoid browser errors
        flash[:notice] = "Too many genes (#{@nr_genes}) in list - please limit to 400 genes"
        rc = 'e3'
      
      elsif !params[:oligo_ids].blank?
        rc = 'id'
    
      elsif !params[:genes].blank?
        rc = 'gt'
      
      else
        flash[:notice] = 'Please select project, gene(s) or id(s)' 
        rc = 'e2'
      end
    end
    
    return rc  
  end

  def define_conditions(params, ptype)
    condition_array    = []
    condition_array[0] = 'blank'
    select_conditions  = []
    
    case ptype
      when 'id' #list of ids entered
        id_list = create_array_from_text_area(params[:oligo_ids], 'integer')
        select_conditions.push("CAST(SUBSTRING_INDEX(synth_oligos.oligo_name,'_',1) AS UNSIGNED) IN (?)")
        condition_array.push(id_list)
      
      when 'gl'  # gene list entered (from drop-down)
        select_conditions.push('synth_oligos.gene_code IN (?)')
        condition_array.push(ProjectGene.genelist(nil, params[:oligo_design][:gene_code]))
      
      when 'gt'  # gene list entered as text
        select_conditions.push('synth_oligos.gene_code IN (?)')
        condition_array.push(ProjectGene.genelist(nil, create_array_from_text_area(params[:genes])))
        
      when 'p' # project entered, with "all genes" selected, or no selection made
        select_conditions.push('synth_oligos.gene_code IN (?)')
        condition_array.push(ProjectGene.genelist(params[:project], nil))
        
      else
        error_found = true
        flash[:notice] = "Unknown error, parameter check rc = #{@rc}"
    end
    
    if !error_found
      # add condition for well remaining volume gt threshold volume (currently hardcoded as 10)
      select_conditions.push('oligo_wells.well_rem_volume > ?')
      condition_array.push(10)
      
      # add condition for version id(s)
      if params[:version] && !param_blank?(params[:version][:id])
        select_conditions.push('synth_oligos.version_id IN (?)')
        condition_array.push(params[:version][:id])
      end
      
      # add condition for enzymes
      if params[:enzyme] && !param_blank?(params[:enzyme][:enzyme_code])
        select_conditions.push('synth_oligos.enzyme_code IN (?)')
        condition_array.push(enzyme_add_gapfill(params[:enzyme][:enzyme_code]))
      end
      
      condition_array[0] = select_conditions.join(' AND ') 
      return condition_array
      
    else
      return nil
    end
  end

protected
  def dropdowns
    @projects = Project.find(:all)
    @versions = Version.find(:all)
  end
end
