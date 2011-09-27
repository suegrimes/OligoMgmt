# == Schema Information
#
# Table name: export_counts
#
#  id              :integer(4)      not null, primary key
#  export_cnt      :integer(4)      default(0)
#  zipdownload_cnt :integer(4)      default(0)
#  created_at      :datetime
#  updated_at      :timestamp
#

class ExportCount < ActiveRecord::Base

end
