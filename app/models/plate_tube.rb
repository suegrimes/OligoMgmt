# == Schema Information
# Schema version: 20090121183010
#
# Table name: plate_tubes
#
#  id                 :integer(4)      not null, primary key
#  plate_or_tube_name :string(25)      default(""), not null
#  plate_number       :integer(3)
#  synthesis_date     :date
#  description        :string(255)
#  updated_at         :timestamp
#

class PlateTube < InventoryDB
  has_many :plate_positions, :foreign_key => :plate_or_tube_id
  
  def self.find_all_incl_oligos(condition_array=nil)
    #Convoluted sort order is needed because sorting alphabetically the 'M' plates would sort as M1,M10,M11,..M2,M20 etc),
    #and sorting numerically by plate_number would mix M plates and standard plates since there is M10 and 0010 for example)
    self.find(:all, :include => {:plate_positions => :synth_oligos}, 
                    :order => 'LEFT(plate_or_tube_name,1), plate_number',
                    :conditions => condition_array)
  end
  
  def self.find_min_and_max_plates
    plate_or_tube_names = self.find(:all, :conditions => "plate_or_tube_name LIKE 'M%'").collect{|plate| plate.plate_or_tube_name[1,2].to_i}
    return plate_or_tube_names.min, plate_or_tube_names.max
  end
  
  def self.find_min_and_max_dates
    synth_dates = self.find(:all, :conditions => "synthesis_date IS NOT NULL").collect(&:synthesis_date)
    return synth_dates.min, synth_dates.max
  end
end
