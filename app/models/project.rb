# == Schema Information
#
# Table name: projects
#
#  id                  :integer(4)      not null, primary key
#  project_name        :string(50)      default(""), not null
#  project_description :string(255)
#  version_id          :integer(4)
#

class Project < ActiveRecord::Base
  has_many :project_genes
  after_update :save_genes
  
  validates_uniqueness_of :project_name, :message => 'already exists'
  
  def new_gene_attributes=(gene_attributes)
    gene_attributes.each do |attributes|
      project_genes.build(attributes)
    end
  end
  
  def existing_gene_attributes=(gene_attributes)
    project_genes.reject(&:new_record?).each do |project_gene|
      attributes = gene_attributes[project_gene.id.to_s]
      if attributes
        project_gene.attributes = attributes
      else
        project_genes.delete(project_gene)
      end
    end
  end
  
  def self.findall_proj
    self.find(:all, :order => :project_name)
  end
  
  def delete_incl_children
    ProjectGene.delete_project(id)
    destroy 
  end
  
  def save_genes
    project_genes.each do |project_gene|
      project_gene.save(false)  
    end
  end
end
