# == Schema Information
# Schema version: 20090121183010
#
# Table name: pools
#
#  id               :integer(4)      not null, primary key
#  pool_name        :string(35)      default(""), not null
#  tube_label       :string(15)      default(""), not null
#  pool_description :string(80)
#  enzyme_code      :string(50)
#  source_conc_um   :decimal(8, 3)
#  pool_volume      :decimal(8, 3)
#  project_id       :integer(2)
#  notes            :string(255)
#  updated_at       :timestamp
#

class Pool < ActiveRecord::Base
  has_many :aliquot_to_pools
  has_many :plate_positions, :through => :aliquot_to_pools
  belongs_to :storage_location
  
  accepts_nested_attributes_for :aliquot_to_pools
  
  validates_presence_of :tube_label
end
