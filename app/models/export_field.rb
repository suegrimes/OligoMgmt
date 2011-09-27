# == Schema Information
#
# Table name: export_fields
#
#  id           :integer(4)      not null, primary key
#  export_type  :integer(1)
#  model_nm     :string(50)      default(""), not null
#  report_order :integer(2)
#  fld_heading  :string(25)
#  fld_name     :string(50)
#

class ExportField < ActiveRecord::Base
  
EXPORT_FMT = 1

def self.headings(xfmt=EXPORT_FMT)
  rpt_hdgs = self.find(:all, :order => :report_order, :conditions => ['export_type = ?', xfmt])
  rpt_hdgs.collect(&:fld_heading)  
end

def self.fld_names(xfmt=EXPORT_FMT)
  rpt_flds = self.find(:all, :order => :report_order, :conditions => ['export_type = ?', xfmt])
  rpt_flds.collect{|xport| [xport.model_nm, xport.fld_name]}
end

end
