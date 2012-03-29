# == Schema Information
# Schema version: 20090121183010
#
# Table name: aliquot_to_pools
#
#  id                :integer(4)      not null, primary key
#  plate_position_id :integer(4)      not null
#  pool_id           :integer(4)      not null
#  subpool           :string(25)
#  volume            :decimal(8, 3)   default(0.0), not null
#  updated_at        :timestamp
#

class AliquotToPool < InventoryDB
  belongs_to :plate_position
  belongs_to :pool
end
