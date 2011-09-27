class OligoDesignsController < ApplicationController
  require_role "admin", :for => [:new, :create, :edit, :update]
  skip_before_filter :login_required, :only => :welcome
  
  def welcome    
  end
  
  def export_design
    export_type = 'T1'
    @version_id = Version::version_id_or_default(params[:version_id])
    @oligo_designs = OligoDesign.find_oligos_with_conditions(["id IN (?)", params[:export_id]], @version_id)   
    file_basename  = "oligodesigns_" + Date.today.to_s
    
    case export_type
      when 'T1'  # Export to tab-delimited text using csv_string
        @filename = file_basename + ".txt"
        csv_string = export_designs_csv(@oligo_designs)
        send_data(csv_string,
          :type => 'text/csv; charset=utf-8; header=present',
          :filename => @filename, :disposition => 'attachment')
          
      # To export using this method, need a version of export_design.html with tabs, and without any html markup
      when 'T2' # Export to tab-delimited text using export_design_txt.html (currently doesn't exist)
        @filename = file_basename + ".txt"
        headers['Content-Type']="text/x-csv"
        headers['Content-Disposition']="attachment;filename=\"" + @filename + "\""
        headers['Cache-Control'] = '' 
        render :action => :export_design, :layout => false
        
      when 'E'  # Export to Excel using export_design.html
        @filename = file_basename + ".xls"
        headers['Content-Type']="application/vnd.ms-excel"
        headers['Content-Disposition']="attachment;filename=\"" + @filename + "\""
        headers['Cache-Control'] = ''
        render :action => :export_design, :layout => false  
      
      else # Use for debugging
        csv_string = export_designs_csv(@oligo_designs)
        render :text => csv_string
      end
  end
  
  
  # GET /oligo_designs
  def index
    @oligo_designs = OligoDesign.curr_ver.find(:all)
  end
  
  # GET /oligo_designs/1
  def show
    @oligo_design = OligoDesign.find(params[:id], :include => :oligo_annotation )
    @comments     = @oligo_design.comments.sort_by(&:created_at).reverse
  end
  
  #*******************************************************************************************#
  # Methods for input of parameters for retrieval of specific oligo designs                   #
  #*******************************************************************************************#
  def select_project
    @projects = Project.find(:all)
  end
  
  def select_params
    @versions = Version.find(:all)
    @enzymes = OligoDesign::ENZYMES_WO_GAPFILL
    @project_id = (params[:project] ? params[:project][:project_id] : '')
    
    if !@project_id.blank?
      @proj_genes = ProjectGene.find_proj_genes(@project_id)
      @project    = Project.find_by_id(@project_id)
      @version    = Version.find(@project.version_id) # set version as default for select box
      render :action => 'select_proj_genes'
    else
      @version = Version.curr_version.find(:first) # set version as default for select box
      render :action => 'select_genes_or_ids'
    end   
    
  end

  #*******************************************************************************************#
  # Method for listing oligo designs, based on parameters entered above                       #
  #*******************************************************************************************#
  def list_selected
    param_type = params[:param_type] ||= 'proj_gene'
    @version_id = Version::version_id_or_default(params[:version][:id])
    
    error_found = false 
    # check for correct number of parameters entered
    # must have project/gene(s), or id(s)
    @rc = check_params(params, param_type)
    
    if @rc =~ /e\d/ # error code ('e' followed by digit)
      error_found    = true   
    else
      @condition_array = define_conditions(params, @rc, @version_id)
      excl_flagged     = (params[:excl_flagged] == 'true' ? 'yes' : 'no')
      @oligo_designs   = OligoDesign.find_oligos_with_conditions(@condition_array, @version_id,
                                                                {:excl_flagged => excl_flagged})
      # return error if no oligos found
      error_found = check_if_blank(@oligo_designs, 'oligos', @rc)      
    end
  
    if error_found
      redirect_to :action => 'select_params', :project => params[:project]
    else
      render :action => 'list_selected'
    end
  end
  
  #*******************************************************************************************#
  # Method for download of zip file of oligos for entire exonome                              #    
  #*******************************************************************************************#
  def zip_download
    download_zip_file if request.post?
  end
  
  #*******************************************************************************************#
  # Method for adding comment associated with a specific oligo                                #    
  #*******************************************************************************************#
  def add_comment
    unless params[:comment].nil? || params[:comment]== ''
      @oligo_design = OligoDesign.find(params[:id])
      store_comment(@oligo_design, params)
    end
    
    redirect_to :action => 'show', :id => params[:id]
  end
  
  private
  #*******************************************************************************************#
  # Method for checking parameters from "select_proj_genes", and "select_genes_or_ids" views  #
  #*******************************************************************************************#
  def check_params(params, param_type)
    if param_type == 'proj_gene'
      if params[:oligo_design] && params[:oligo_design][:gene_code]
      # if gene_list[0].blank? then "all genes" was selected from drop-down
      # set rc=p if "all genes", => retrieve all genes for the selected project
      # set rc=g otherwise,      => retrieve just the genes selected
        gene_list = params[:oligo_design][:gene_code]
        rc = (gene_list[0].blank? ? 'p' : 'gl')
      
      elsif params[:project] 
        #only project entered, so will retrieve all genes for that project
        rc = 'p'
      else
        # error - neither project or gene were selected
        flash[:notice] = 'Please select project and/or gene(s)'
        rc = 'e2'
      end
      
    else #param_type == 'gene_id'
      nr_genes = params[:genes].split.size if params[:genes]
      if nr_genes && nr_genes > 400
        params[:genes] = ''  #reset params[:genes] to avoid browser errors
        flash[:notice] = "Too many genes (#{nr_genes}) in list - please limit to 400 genes"
        rc = 'e3'
        
      # oligo ids if entered, take priority over genes, so check for ids first
      elsif !params[:oligo_ids].blank?
        rc = 'id'
      
      elsif !params[:genes].blank?
        rc = 'gt'
   
      else
        # error - both genes and oligo ids are blank
        flash[:notice] = 'Please select gene(s) or id(s)'
        rc = 'e4'
      end
    end
    
    return rc
  end
  
  #*******************************************************************************************#
  # Method for creating sql condition array, based on parameters entered                      #
  #*******************************************************************************************#
  def define_conditions(params, ptype, version_id)
    condition_array = []
    condition_array[0] = 'blank'
    select_conditions = []
    
    case ptype
      when 'id' #list of ids entered
        id_list = create_array_from_text_area(params[:oligo_ids], 'integer')
        select_conditions.push('id IN (?)')
        condition_array.push(id_list)
      
      when 'gl'  #gene list entered (as array from drop-down)
        gene_list      = params[:oligo_design][:gene_code]
        select_conditions.push('gene_code IN (?)')
        condition_array.push(gene_list)
      
      when 'gt'  #gene list entered (as text)
        gene_list      = create_array_from_text_area(params[:genes])
        select_conditions.push('gene_code IN (?)')
        condition_array.push(gene_list)
      
      when 'p' #project entered, without entering specific genes, so get all genes for project
        gene_list      = ProjectGene.genelist(params[:project], nil)
        select_conditions.push('gene_code IN (?)')
        condition_array.push(gene_list)
    end
    
    if params[:enzyme] && !param_blank?(params[:enzyme][:enzyme_code])
      select_conditions.push('enzyme_code IN (?)')
      condition_array.push(enzyme_add_gapfill(params[:enzyme][:enzyme_code]))
    end
    
    select_conditions.push('version_id = ?')
    condition_array.push(version_id)
    condition_array[0] = select_conditions.join(' AND ')
    return condition_array 
  end
  
  #*******************************************************************************************#
  # Export oligo designs to csv file                                                          #    
  #*******************************************************************************************#
  def export_designs_csv(oligo_designs, fmt_nr=2)
    csv_string = FasterCSV.generate(:col_sep => "\t") do |csv|
      csv << ['Date', 'Project'].concat(ExportField.headings(fmt_nr))
      
      oligo_designs.each do |oligo_design|
        fld_array = []
        oligo_annotation = oligo_design.oligo_annotation
        
        ExportField.fld_names(fmt_nr).each do |model, fld|
          if model == 'oligo_design'
            fld_array << oligo_design.send(fld)
            
          elsif model == 'oligo_annotation'
            fld_array << oligo_annotation.send(fld) if oligo_annotation
            fld_array << ' '                        if oligo_annotation.nil?
          end
        end
        
        csv << [Date.today.to_s, 'NA'].concat(fld_array)
      end
    end
    return csv_string
  end
  
  #*******************************************************************************************#
  # Download zip file                                                                         #    
  #*******************************************************************************************#
  def download_zip_file
    filepath = File.join(OligoDesign::ZIP_FILE_ROOT, "oligo_exonome.zip") 
    
    if FileTest.file?(filepath)
      flash[:notice] = "Zip file successfully downloaded"
      send_file(filepath, :disposition => "attachment")
    else
      flash[:notice] = "Error downloading zip file - file not found"
    end
  end
  
end