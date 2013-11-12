# == Schema Information
# Schema version: 20090121183010
#
# Table name: synth_oligos
#
#  id                :integer(4)      not null, primary key
#  plate_position_id :integer(4)
#  oligo_name        :string(100)     default(""), not null
#  oligo_id          :integer(4)
#  oligo_type        :string(30)
#  chromosome_nr     :string(2)
#  gene_code         :string(50)
#  enzyme_code       :string(15)
#  chr_start_pos     :integer(4)
#  strand            :string(5)
#  sequence          :string(255)     default(""), not null
#  notes             :string(255)
#  version_id        :integer(1)
#  updated_at        :timestamp
#

class SynthOligo < InventoryDB
  belongs_to :plate_position
  belongs_to :oligo, :polymorphic => true
  
  def dna_sequence
    # Delete any of the following characters from ordered oligo: space, P, X, 5, '-', or single quote
    # Convert any lowercase letters to uppercase
    sequence.upcase.gsub(/([' 'PX5\-\'])/, '') 
  end
  
  def self.find_all_incl_plate(condition_array=nil)
#    self.find(:all, :include => {:plate_position => :plate_tube}, 
#                    :order => 'plate_tubes.plate_number, plate_positions.well_number',
#                    :conditions => condition_array)
     self.includes(:plate_position => :plate_tube).order('plate_tubes.plate_number, plate_positions.well_number').where(sql_where(condition_array)).all
  end
  
  def self.find_with_id_list(id_list)
    self.includes(:plate_position => :plate_tube).order('gene_code, enzyme_code').where('id in (?)', id_list).all
    #self.find(:all, :include => {:plate_position => :plate_tube},
    #                :order => 'gene_code, enzyme_code',
    #                :conditions => ["id IN (?)", id_list])
  end
end
