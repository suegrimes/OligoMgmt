# == Schema Information
# Schema version: 20090121183010
#
# Table name: enzymes
#
#  id                      :integer(4)      not null, primary key
#  enzyme_name             :string(20)
#  enzyme_descr            :string(255)
#  recognition_seq         :string(30)
#  cut_pos1                :int(2)
#  cut_pos2                :int(2)
#  cut_pos3                :int(2)
#

class Enzyme < ActiveRecord::Base
  ENZYMES = Enzyme.all.pluck(:enzyme_name)
  ENZYMES_WO_GAPFILL = ENZYMES.reject { |enzyme| enzyme =~ /.*_gapfill/}
end
