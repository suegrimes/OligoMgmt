class InventoryDB < ActiveRecord::Base
  self.abstract_class = true
  establish_connection (:inventory) if Rails.env == 'production' 
end