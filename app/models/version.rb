# == Schema Information
# Schema version: 20090121183010
#
# Table name: versions
#
#  id                    :integer(4)      not null, primary key
#  version_for_synthesis :string(1)
#  exonome_or_partial    :string(1)
#  genome_build          :string(15)      default(""), not null
#  ccds_build            :string(15)
#  dbsnp_build           :string(15)
#  design_version        :string(15)      default(""), not null
#  version_name          :string(50)
#  vector_id             :integer(4)
#  archive_flag          :string(1)
#  genome_build_notes    :string(255)
#  design_version_notes  :string(255)
#  created_at            :datetime
#  updated_at            :timestamp       not null
#

class Version < ActiveRecord::Base  
  belongs_to :vector
  has_many :gene_lists, :as => :list_owner
  
  scope :curr_version, :conditions => {:archive_flag => 'C'}, :order => 'id DESC'
  scope :exome_version, :conditions => {:exonome_or_partial => 'E'}
  
  before_save(version)
    version.archive_flag = (version.exonome_or_partial == 'E' ? 'C' : 'P')
  end
  
  #VERSIONS = self.find(:all)
  VERSIONS = self.all
  #DESIGN_VERSION = self.curr_version.find(:first)
  DESIGN_VERSION = self.exome_version.curr_version.first
  DESIGN_VERSION_ID = DESIGN_VERSION.id
  DESIGN_VERSION_NAMES = DESIGN_VERSION.genome_build + "/" + DESIGN_VERSION.design_version
  
  BUILD_VERSION_NAMES = self.all.map {|version| [version.id, 
                            [version.exonome_or_partial, version.genome_build, version.design_version].join('/')]}
 
  #read App_Versions file to set current application version #
  #version# is first row, first column  
  filepath = "#{Rails.root}/app/assets/app_versions.txt"
  if FileTest.file?(filepath)
    app_version_row1 = CSV.read(filepath, {:col_sep => "\t"})[0]
    end
  APP_VERSION = (app_version_row1 ? app_version_row1[0] : '??')
  
  def version_id_name
    return "#{id.to_s}:#{version_name}(#{genome_build})"
  end
  
  def version_id_flagged_name
    #flag current version with asterisk, for use in select box
    (id == DESIGN_VERSION.id ? ['*', version_id_name].join('') : [' ', version_id_name].join(''))
  end
  
  def oligo_model
    model = case 
      when exonome_or_partial == 'P' then 'PilotOligoDesign'
      when archive_flag == 'A'       then 'ArchiveOligoDesign'
      else 'OligoDesign'
      end
    return model
  end
  
  def self.version_id_or_default(id_num)
    return (id_num.blank? ? DESIGN_VERSION_ID : id_num.to_i)
  end
  
end
