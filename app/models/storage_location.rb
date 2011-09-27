# == Schema Information
# Schema version: 20090121183010
#
# Table name: storage_locations
#
#  id         :integer(4)      not null, primary key
#  room_nr    :string(25)      default(""), not null
#  shelf_nr   :string(25)
#  bin_nr     :string(25)
#  box_nr     :string(25)
#  comments   :string(255)
#  created_at :datetime
#  updated_at :timestamp
#

class StorageLocation < InventoryDB
  
  #validates_uniqueness_of :location_string
  
  def location_string
    [room_nr, shelf_nr, bin_nr, box_nr].join('/')
  end
  
end
