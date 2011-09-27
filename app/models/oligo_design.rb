# == Schema Information
# Schema version: 20090121183010
#
# Table name: oligo_designs
#
#  id                      :integer(4)      not null, primary key
#  oligo_name              :string(100)     default(""), not null
#  target_region_id        :integer(4)      default(0), not null
#  valid_oligo             :string(1)       default(""), not null
#  chromosome_nr           :string(3)
#  gene_code               :string(25)
#  enzyme_code             :string(20)
#  selector_nr             :integer(3)
#  roi_nr                  :integer(2)
#  internal_QC             :string(2)
#  annotation_codes        :string(20)
#  other_annotations       :string(20)
#  sel_n_sites_start       :integer(1)
#  sel_left_start_rel_pos  :integer(2)
#  sel_left_end_rel_pos    :integer(2)
#  sel_left_site_used      :integer(1)
#  sel_right_start_rel_pos :integer(2)
#  sel_right_end_rel_pos   :integer(2)
#  sel_right_site_used     :integer(1)
#  sel_polarity            :string(1)
#  sel_5prime              :string(30)
#  sel_3prime              :string(30)
#  usel_5prime             :string(30)
#  usel_3prime             :string(30)
#  selector_useq           :string(255)
#  amplicon_chr_start_pos  :integer(4)
#  amplicon_chr_end_pos    :integer(4)
#  amplicon_length         :integer(4)
#  amplicon_seq            :text
#  version_id              :integer(4)
#  genome_build            :string(25)
#  created_at              :datetime
#  updated_at              :datetime
#

class OligoDesign < ActiveRecord::Base
# PilotOligoDesign inherits from this model class, therefore any table name references must be generic, 
# or method must be passed a parameter to indicate which model the method is accessing
  acts_as_commentable
 
  has_one  :oligo_annotation, :foreign_key => :oligo_design_id
  
  validates_uniqueness_of :oligo_name,
                          :on  => :create  
                          
  named_scope :curr_ver, :conditions => ['version_id = (?)', Version::DESIGN_VERSION.id ]
  named_scope :qcpassed, :conditions => ['internal_QC IS NULL OR internal_QC = " " ']
  named_scope :notflagged, :conditions => ['annotation_codes IS NULL OR annotation_codes < "A" ']
  
  unique_enzymes = self.curr_ver.find(:all, 
                                      :select => "DISTINCT(enzyme_code)",
                                      :order  => :enzyme_code)
  ENZYMES = unique_enzymes.map{ |design| design.enzyme_code }
  ENZYMES_WO_GAPFILL = ENZYMES.reject { |enzyme| enzyme =~ /.*_gapfill/}
  #VECTOR = 'ACGATAACGGTACAAGGCTAAAGCTTTGCTAACGGTCGAG'

  #****************************************************************************************#
  #  Define virtual attributes                                                             #
  #****************************************************************************************#
  
  def polarity
    (sel_polarity == 'p' ? 'plus' : 'minus')
  end
  
  def usel_vector
    selector_useq[21,40]
  end
  
  def selector
    [sel_5prime, Vector::VECTOR, sel_3prime].join('')
  end
  
  def chr_target_start
    (amplicon_chr_start_pos -  sel_left_start_rel_pos + 1)
  end
  
  def roi_ids_of_selectors
    [gene_code, 'ROI', roi_nr].join('_')
  end
  
  #****************************************************************************************#
  #  Class find methods   - Oligos                                                         #
  #****************************************************************************************#
  
  def self.find_using_oligo_name_id(oligo_name)
    # Use id or gene_code index to speed retrieval.
    # Note: curr_oligo_format?, and get_gene_from_name are in OligoExtensions module
    
    if curr_oligo_format?(oligo_name)                            
      # oligo name in current format, => use id as index
      oligo_array  = oligo_name.split(/_/)
      oligo_design = self.find_by_oligo_name_and_id(oligo_name, oligo_array[0])
    else
      # oligo name in old format => cannot use id, use gene code instead
      #gene_code    = self.get_gene_from_name(oligo_name, false)
      gene_code    = get_gene_from_oligo_name(oligo_name, false) 
      oligo_design = self.find_by_oligo_name_and_gene_code(oligo_name, gene_code)
    end
    
    return oligo_design
  end
  
  def self.find_selectors_with_conditions(condition_array, version_id=Version::DESIGN_VERSION_ID)
    condition_array[0] += ' AND version_id = ?'
    condition_array.push(version_id)
    
    self.qcpassed.find(:all,
                       :order => 'gene_code, enzyme_code',                               
                       :conditions => condition_array) 
  end
  
  def self.find_with_id_list(id_list)
    self.find(:all, :include => :oligo_annotation,
                    :order => 'gene_code, enzyme_code',
                    :conditions => ["id IN (?)", id_list])
  end
  
end
