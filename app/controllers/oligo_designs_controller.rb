class OligoDesignsController < ApplicationController
  require_role "admin", :for => [:new, :create, :edit, :update]
  
  # GET /oligo_designs/1
  def show
    @oligo_design = OligoDesign.find(params[:id], :include => [:oligo_annotation, :version] )
    @comments     = @oligo_design.comments.sort_by(&:created_at).reverse
  end
  
  #*******************************************************************************************#
  # Methods for input of parameters for retrieval of specific oligo designs                   #
  #*******************************************************************************************#
  def new_query
    @versions = Version.curr_version.find(:all, :order => :id)
    @enzymes = OligoDesign::ENZYMES_WO_GAPFILL 
  end

  #*******************************************************************************************#
  # Method for listing oligo designs, based on parameters entered above                       #
  #*******************************************************************************************#
  def index
    #@version = (params[:version] ? Version.find(params[:version][:id]) : Version::DESIGN_VERSION)
    @version = Version.find(params[:version][:id], :include => :gene_lists)
    @condition_array = define_conditions(params, @version.id)  
    
    @oligo_designs   = OligoDesign.find_oligos_with_conditions(@condition_array, @version.id)
    # return error if no oligos found
    error_found = check_if_blank(@oligo_designs, 'oligos') 
    
    if error_found
      redirect_to :action => 'new_query'
    else
      render :action => 'index'
    end
  end
  
  #*******************************************************************************************#
  # Method for exporting oligos from 'index' view                                             #    
  #*******************************************************************************************#
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
  
  #*******************************************************************************************#
  # Ajax method to populate gene or project list, based on selected design version            #
  #*******************************************************************************************#  
  def get_gene_list
    @version = Version.find(params[:version_id], :include => :gene_lists)
    
    if @version.exonome_or_partial == 'P'
      @genes = @version.gene_lists.collect{|genes| genes[:gene_code]} 
      render :update do |page|
        if !@genes.nil?
          page.replace_html 'gene_list', :partial => 'gene_list', :genes => @genes
        else
          page.replace_html 'gene_list', '<p>No genes found for this version, in gene_lists table</p>'
        end
      end
      
    else
      @projects = Project.find(:all)
      render :update do |page|
        page.replace_html 'gene_list', :partial => 'gene_text'
      end
    end
  end
  
  protected
  #*******************************************************************************************#
  # Ajax method to populate gene list, based on selected design version                       #
  #*******************************************************************************************#  
  def define_conditions(params, version_id=Version::DESIGN_VERSION_ID)
    @where_select = ['version_id = ?']
    @where_values = [version_id]

    if params[:gene_string]
      gene_array = create_array_from_text_area(params[:gene_string])
    elsif params[:pilot_oligo_design] && !param_blank?(params[:pilot_oligo_design][:gene_code])
      gene_array = params[:pilot_oligo_design][:gene_code] 
    end
    
    if gene_array
      @where_select.push("gene_code IN (?)")
      @where_values.push(gene_array)
    end
    
    sql_where_clause = (@where_select.length == 0 ? [] : [@where_select.join(' AND ')].concat(@where_values))
    return sql_where_clause
  end  
  
  private  
  #*******************************************************************************************#
  # Export oligo designs to csv file                                                          #    
  #*******************************************************************************************#
  def export_designs_csv(oligo_designs, fmt_nr=1)
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