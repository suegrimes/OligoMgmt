# == Schema Information
#
# Table name: researchers
#
#  id                  :integer(4)      not null, primary key
#  researcher_name     :string(50)      default(""), not null
#  researcher_initials :string(3)       default(""), not null
#  company             :string(50)
#  phone_number        :string(20)
#

class Researcher < ActiveRecord::Base
  
  validates_uniqueness_of :researcher_name, :researcher_initials
  
end
