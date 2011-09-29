# == Schema Information
#
# Table name: project_genes
#
#  id         :integer(4)      not null, primary key
#  project_id :integer(4)      not null
#  gene_code  :string(25)      default(""), not null
#

class ProjectGene < ActiveRecord::Base
  belongs_to :project
  
  def self.find_proj_genes(project_id)
    self.find(:all, :select => "gene_code",
                    :conditions => ["project_id = ?", project_id],
                    :order => "gene_code")
  end
  
  def self.genelist(project, genelist)
    # if one or more projects were selected, push associated gene_codes to gene list
    @proj_genes = Array.new   
    if project
      @projects = ProjectGene.find_all_by_project_id(project[:project_id], :order => "gene_code")
      @projects.each do |gene|
        @proj_genes.push(gene.gene_code)
      end
    end
    
    # add genes from text area array, if any were submitted
    @gene_list = Array.new 
    @gene_list = (genelist.is_a?(Array) ? genelist : []) if genelist
    
    return (@proj_genes | @gene_list).sort
  end
  
  def self.add_genes(projid, genelist)
    @save_cnt = @reject_cnt = 0
    
    genelist.each do |gene| 
      @project_gene = self.new(:project_id => projid,
                               :gene_code  => gene)   
       if @project_gene.save
         @save_cnt += 1
       else
         logger.error("Unable to save project id: #{projid}, gene: #{@gene}")
         @reject_cnt +=1
       end 
     end
     
   return @save_cnt
 end
 
 def self.delete_project(project_id)
   @project_genes = self.find_all_by_project_id(project_id)
   @project_genes.each do |project_gene|
     project_gene.destroy
   end
 end
  
end
