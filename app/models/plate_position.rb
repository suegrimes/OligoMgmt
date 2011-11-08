# == Schema Information
# Schema version: 20090121183010
#
# Table name: plate_positions
#
#  id                 :integer(4)      not null, primary key
#  oligo_name         :string(100)     default(""), not null
#  oligo_usage        :string(1)
#  plate_or_tube_name :string(30)
#  plate_or_tube_id   :integer(4)
#  well_number        :string(3)
#  plate_position     :integer(2)      default(0), not null
#  updated_at         :timestamp
#

class PlatePosition < InventoryDB
  belongs_to :plate_tube, :foreign_key => :plate_or_tube_id
  has_many :synth_oligos
  has_many :aliquot_to_pools
  has_many :pools, :through => :aliquot_to_pools
  
  WELL_LETTER = %w{A B C D E F G H}
  OLIGO_USAGE = {:V => 'Vector', :A => 'Adapter', :P => 'Primer', :S => 'Selector', :Q => 'OS-Seq', 
                 :T => 'SV Tiling', :O => 'Other Oligo'}
  
  def oligo_usage_descr
    (oligo_usage.blank? ? 'Unknown' : OLIGO_USAGE[oligo_usage.to_sym])
  end
  
  def plate_number
    case plate_or_tube_name
      when /^M(\d+)$/  then $1.to_i
      when /^.*_(\d+)$/ then $1.to_i
      else 0
    end
  end
  
  def well_coord
    well_alpha = WELL_LETTER[(plate_position - 1)/12]
    well_num   = (plate_position - 1) % 12 + 1 
    return well_alpha + well_num.to_s
  end
  
  def self.find_all_positions(condition_array=nil)
    self.find(:all, :include => :plate_tube, :order => 'plate_positions.plate_or_tube_name, plate_position',
                    :conditions => condition_array)
  end
  
  def self.find_all_incl_oligos(condition_array=nil)
    self.find(:all, :include => :synth_oligos, :order => 'plate_positions.plate_or_tube_name, plate_position',
                    :conditions => condition_array)
  end
  
end
