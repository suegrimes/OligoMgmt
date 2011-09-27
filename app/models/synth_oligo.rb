# == Schema Information
# Schema version: 20090121183010
#
# Table name: synth_oligos
#
#  id                :integer(4)      not null, primary key
#  plate_position_id :integer(4)
#  oligo_name        :string(100)     default(""), not null
#  oligo_usage       :string(2)
#  oligo_id          :integer(4)
#  oligo_type        :string(30)
#  chromosome_nr     :string(2)
#  gene_code         :string(50)
#  enzyme_code       :string(15)
#  sequence          :string(255)     default(""), not null
#  notes             :string(255)
#  updated_at        :timestamp
#

class SynthOligo < ActiveRecord::Base
  belongs_to :plate_position
  
  OLIGO_USAGE = {:V => 'Vector', :A => 'Adapter', :P => 'Primer', :S => 'Selector', :Q => 'OS-Seq', 
                 :T => 'SV Tiling', :O => 'Other Oligo'}
  
  def oligo_usage_descr
    (oligo_usage.blank? ? 'Unknown' : OLIGO_USAGE[oligo_usage.to_sym])
  end
  
  def dna_sequence
    # Delete any of the following characters from ordered oligo: space, P, X, 5, '-', or single quote
    # Convert any lowercase letters to uppercase
    sequence.upcase.gsub(/([' 'PX5\-\'])/, '') 
  end
  
  def self.find_all_incl_plate(condition_array=nil)
    self.find(:all, :include => :plate_position, :order => 'plate_positions.plate_number, plate_positions.well_order',
                         :conditions => condition_array)
  end
end
