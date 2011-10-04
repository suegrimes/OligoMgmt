# == Schema Information
# Schema version: 20090121183010
#
# Table name: pilot_oligo_designs
#
#  id                      :integer(4)      not null, primary key
#  oligo_name              :string(100)     default(""), not null
#  target_region_id        :integer(4)      default(0)
#  valid_oligo             :string(1)
#  chromosome_nr           :string(3)
#  gene_code               :string(25)
#  enzyme_code             :string(20)
#  selector_nr             :integer(3)
#  roi_nr                  :integer(2)
#  internal_QC             :string(2)
#  annotation_codes        :string(20)
#  other_annotations       :string(20)
#  sel_n_sites_start       :integer(1)
#  sel_left_start_rel_pos  :integer(2)
#  sel_left_end_rel_pos    :integer(2)
#  sel_left_site_used      :integer(1)
#  sel_right_start_rel_pos :integer(2)
#  sel_right_end_rel_pos   :integer(2)
#  sel_right_site_used     :integer(1)
#  sel_polarity            :string(1)
#  sel_5prime              :string(30)
#  sel_3prime              :string(30)
#  usel_5prime             :string(30)
#  usel_3prime             :string(30)
#  selector_useq           :string(255)
#  amplicon_chr_start_pos  :integer(4)
#  amplicon_chr_end_pos    :integer(4)
#  amplicon_length         :integer(4)
#  amplicon_seq            :text
#  version_id              :integer(4)
#  genome_build            :string(25)
#  created_at              :datetime
#  updated_at              :datetime
#

class PilotOligoDesign < OligoDesign
  set_table_name 'pilot_oligo_designs' 
end
