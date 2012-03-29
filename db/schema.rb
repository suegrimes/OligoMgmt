# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090121183010) do

  create_table "aliquot_to_pools", :force => true do |t|
    t.integer   "plate_position_id",                                                              :null => false
    t.integer   "pool_id",                                                                        :null => false
    t.string    "subpool",           :limit => 25
    t.decimal   "volume",                          :precision => 8, :scale => 3, :default => 0.0, :null => false
    t.timestamp "updated_at"
  end

  add_index "aliquot_to_pools", ["pool_id"], :name => "aq_pool_fk"

  create_table "ccds", :force => true do |t|
    t.integer  "target_region_id",                               :null => false
    t.string   "ccds_code",        :limit => 20, :default => "", :null => false
    t.integer  "version_id"
    t.string   "genome_build",     :limit => 25
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ccds", ["target_region_id"], :name => "cd_region_indx"

  create_table "combined_selectors", :id => false, :force => true do |t|
    t.string "sel_id_per_session"
    t.string "roi_num_per_session"
    t.string "chr_num"
    t.string "chr_target_start"
    t.string "L_sel_start"
    t.string "L_sel_end"
    t.string "R_sel_start"
    t.string "R_sel_end"
    t.string "amplicon_length"
    t.string "n_sites_start"
    t.string "left_site"
    t.string "right_site"
    t.string "polarity"
    t.string "enz"
    t.string "selector"
    t.string "5prime_end_20b_sel"
    t.string "3prime_20b__sel"
    t.string "amplicon_seq"
    t.string "roi_ids_of_selectors"
    t.string "U_selector"
  end

  create_table "created_files", :force => true do |t|
    t.string   "content_type",  :limit => 20, :default => "", :null => false
    t.string   "created_file",                :default => "", :null => false
    t.integer  "researcher_id"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  create_table "gene_lists", :force => true do |t|
    t.integer   "list_owner_id",                                 :null => false
    t.string    "list_owner_type", :limit => 50, :default => "", :null => false
    t.string    "gene_code",       :limit => 50, :default => "", :null => false
    t.integer   "updated_by"
    t.timestamp "updated_at"
  end

  create_table "genes", :force => true do |t|
    t.string   "accession_nr",     :limit => 25
    t.string   "gene_code",        :limit => 25, :default => "", :null => false
    t.integer  "chromosome_nr",    :limit => 2
    t.text     "gene_description"
    t.integer  "version_id"
    t.string   "genome_build",     :limit => 25
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "genes", ["accession_nr"], :name => "accession_ind"
  add_index "genes", ["gene_code"], :name => "gene_code_ind"

  create_table "indicators", :force => true do |t|
    t.integer "last_oligo_plate_nr"
    t.integer "last_pool_plate_nr"
  end

  create_table "misc_oligos", :force => true do |t|
    t.string    "oligo_name",    :limit => 100, :default => "", :null => false
    t.string    "oligo_type",    :limit => 2
    t.string    "sequence",      :limit => 100, :default => "", :null => false
    t.integer   "misc_plate_id"
    t.string    "plate_number",  :limit => 4
    t.integer   "well_order",    :limit => 2,                   :null => false
    t.string    "notes",         :limit => 100
    t.timestamp "updated_at"
  end

  create_table "misc_plates", :force => true do |t|
    t.string    "plate_number",      :limit => 4,  :default => "", :null => false
    t.string    "plate_description", :limit => 50
    t.date      "synthesis_date"
    t.timestamp "updated_at"
  end

  create_table "oligo_designs", :force => true do |t|
    t.string   "oligo_name",              :limit => 100, :default => "", :null => false
    t.integer  "target_region_id",                       :default => 0,  :null => false
    t.string   "valid_oligo",             :limit => 1,   :default => "", :null => false
    t.string   "chromosome_nr",           :limit => 3
    t.string   "gene_code",               :limit => 25
    t.string   "enzyme_code",             :limit => 20
    t.integer  "selector_nr",             :limit => 3
    t.integer  "roi_nr",                  :limit => 2
    t.string   "internal_QC",             :limit => 2
    t.string   "annotation_codes",        :limit => 20
    t.string   "other_annotations",       :limit => 20
    t.integer  "sel_n_sites_start",       :limit => 1
    t.integer  "sel_left_start_rel_pos",  :limit => 2
    t.integer  "sel_left_end_rel_pos",    :limit => 2
    t.integer  "sel_left_site_used",      :limit => 1
    t.integer  "sel_right_start_rel_pos", :limit => 2
    t.integer  "sel_right_end_rel_pos",   :limit => 2
    t.integer  "sel_right_site_used",     :limit => 1
    t.string   "sel_polarity",            :limit => 1
    t.string   "sel_5prime",              :limit => 30
    t.string   "sel_3prime",              :limit => 30
    t.string   "usel_5prime",             :limit => 30
    t.string   "usel_3prime",             :limit => 30
    t.string   "selector_useq"
    t.integer  "amplicon_chr_start_pos"
    t.integer  "amplicon_chr_end_pos"
    t.integer  "amplicon_length"
    t.text     "amplicon_seq"
    t.integer  "version_id"
    t.string   "genome_build",            :limit => 25
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oligo_designs", ["gene_code"], :name => "od_gene_code"

  create_table "oligo_designs_projects", :id => false, :force => true do |t|
    t.integer "oligo_design_id", :null => false
    t.integer "project_id",      :null => false
  end

  create_table "oligo_tubes", :force => true do |t|
    t.integer "row_nr",        :limit => 3
    t.string  "sequence_name"
    t.string  "sequence"
    t.integer "seq_length",    :limit => 2
  end

  create_table "output_target", :id => false, :force => true do |t|
    t.string "roi_id"
    t.string "gene_name"
    t.string "roi_num_per_gene"
    t.string "cds_ids"
    t.string "ccds_ids"
    t.string "g_accession"
    t.string "chr_num"
    t.string "chr_roi_start"
    t.string "chr_roi_stop"
    t.string "roi_strand"
    t.string "chr_target_start"
    t.string "target_roi_start"
    t.string "target_roi_stop"
    t.string "target_seq_clean"
    t.string "target_seq_degenerate"
    t.string "roi_num_per_session"
    t.string "Mse_n_sites_start"
    t.string "Mse_left_site"
    t.string "Mse_right_site"
    t.string "Mse_sel"
    t.string "Bfa_n_sites_start"
    t.string "Bfa_left_site"
    t.string "Bfa_right_site"
    t.string "Bfa_sel"
    t.string "Sau_n_sites_start"
    t.string "Sau_left_site"
    t.string "Sau_right_site"
    t.string "Sau_sel"
    t.string "fold_coverage"
    t.string "MseI_report"
    t.string "BfaI_report"
    t.string "Sau3AI_report"
    t.string "f33"
  end

  create_table "pilot_oligo_designs", :force => true do |t|
    t.string   "oligo_name",              :limit => 100, :default => "", :null => false
    t.integer  "target_region_id",                       :default => 0
    t.string   "valid_oligo",             :limit => 1
    t.string   "chromosome_nr",           :limit => 3
    t.string   "gene_code",               :limit => 25
    t.string   "enzyme_code",             :limit => 20
    t.integer  "selector_nr",             :limit => 3
    t.integer  "roi_nr",                  :limit => 2
    t.string   "internal_QC",             :limit => 2
    t.string   "annotation_codes",        :limit => 20
    t.string   "other_annotations",       :limit => 20
    t.integer  "sel_n_sites_start",       :limit => 1
    t.integer  "sel_left_start_rel_pos",  :limit => 2
    t.integer  "sel_left_end_rel_pos",    :limit => 2
    t.integer  "sel_left_site_used",      :limit => 1
    t.integer  "sel_right_start_rel_pos", :limit => 2
    t.integer  "sel_right_end_rel_pos",   :limit => 2
    t.integer  "sel_right_site_used",     :limit => 1
    t.string   "sel_polarity",            :limit => 1
    t.string   "sel_5prime",              :limit => 30
    t.string   "sel_3prime",              :limit => 30
    t.string   "usel_5prime",             :limit => 30
    t.string   "usel_3prime",             :limit => 30
    t.string   "selector_useq"
    t.integer  "amplicon_chr_start_pos"
    t.integer  "amplicon_chr_end_pos"
    t.integer  "amplicon_length"
    t.text     "amplicon_seq"
    t.integer  "version_id"
    t.string   "genome_build",            :limit => 25
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pilot_oligo_designs", ["gene_code"], :name => "od_gene_code"

  create_table "plate_positions", :force => true do |t|
    t.string    "oligo_name",         :limit => 100, :default => "", :null => false
    t.string    "oligo_usage",        :limit => 1
    t.string    "plate_or_tube_name", :limit => 30
    t.integer   "plate_or_tube_id"
    t.string    "well_number",        :limit => 3
    t.integer   "plate_position",     :limit => 2,   :default => 0,  :null => false
    t.timestamp "updated_at"
  end

  create_table "plate_tubes", :force => true do |t|
    t.string    "plate_or_tube_name", :limit => 25, :default => "", :null => false
    t.integer   "plate_number",       :limit => 3
    t.date      "synthesis_date"
    t.string    "description"
    t.integer   "total_oligos",                     :default => 0,  :null => false
    t.integer   "version_id",         :limit => 3
    t.text      "notes"
    t.timestamp "updated_at"
  end

  create_table "pools", :force => true do |t|
    t.string    "pool_name",           :limit => 35,                                :default => "", :null => false
    t.string    "tube_label",          :limit => 15,                                :default => "", :null => false
    t.string    "pool_description",    :limit => 80
    t.string    "from_pools",          :limit => 100
    t.string    "from_plates",         :limit => 100
    t.integer   "total_oligos",                                                     :default => 0,  :null => false
    t.integer   "cherrypick_oligos",                                                :default => 0,  :null => false
    t.string    "enzyme_code",         :limit => 50
    t.decimal   "source_conc_um",                     :precision => 8, :scale => 3
    t.decimal   "pool_volume",                        :precision => 8, :scale => 3
    t.integer   "project_id",          :limit => 2
    t.integer   "storage_location_id", :limit => 2
    t.string    "notes"
    t.timestamp "updated_at"
  end

  create_table "project_genes", :force => true do |t|
    t.integer "project_id",                               :null => false
    t.string  "gene_code",  :limit => 25, :default => "", :null => false
  end

  create_table "projects", :force => true do |t|
    t.string  "project_name",        :limit => 50, :default => "", :null => false
    t.string  "project_description"
    t.integer "version_id",          :limit => 2
  end

  create_table "researchers", :force => true do |t|
    t.string "researcher_name",     :limit => 50, :default => "", :null => false
    t.string "researcher_initials", :limit => 3,  :default => "", :null => false
    t.string "company",             :limit => 50
    t.string "phone_number",        :limit => 20
  end

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "selector_sites", :force => true do |t|
    t.integer  "target_region_id",                               :null => false
    t.string   "enzyme_code",      :limit => 20, :default => "", :null => false
    t.integer  "n_sites_start",    :limit => 1,                  :null => false
    t.integer  "left_site_used",   :limit => 1
    t.integer  "right_site_used",  :limit => 1
    t.string   "selector"
    t.string   "design_result",                  :default => "", :null => false
    t.integer  "version_id"
    t.string   "genome_build",     :limit => 25
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "selector_sites", ["target_region_id"], :name => "ss_region_indx"

  create_table "storage_locations", :force => true do |t|
    t.string    "room_nr",    :limit => 25, :default => "", :null => false
    t.string    "shelf_nr",   :limit => 25
    t.string    "bin_nr",     :limit => 25
    t.string    "box_nr",     :limit => 25
    t.string    "comments"
    t.datetime  "created_at"
    t.timestamp "updated_at"
  end

  create_table "synth_oligos", :force => true do |t|
    t.integer   "plate_position_id"
    t.string    "oligo_name",        :limit => 100, :default => "", :null => false
    t.integer   "oligo_id"
    t.string    "oligo_type",        :limit => 30
    t.string    "chromosome_nr",     :limit => 2
    t.string    "gene_code",         :limit => 50
    t.string    "enzyme_code",       :limit => 15
    t.integer   "chr_start_pos"
    t.string    "strand",            :limit => 5
    t.string    "sequence",                         :default => "", :null => false
    t.string    "notes"
    t.integer   "version_id",        :limit => 1
    t.timestamp "updated_at"
  end

  create_table "syntheses", :force => true do |t|
    t.string    "researcher",    :limit => 50
    t.string    "gene_code",     :limit => 8
    t.integer   "order_line_nr", :limit => 2
    t.string    "oligo_name",    :limit => 50
    t.string    "selector_useq"
    t.timestamp "created_at"
  end

  create_table "target_regions", :force => true do |t|
    t.integer   "gene_id",                             :null => false
    t.string    "gene_roi",              :limit => 50
    t.integer   "fold_coverage",         :limit => 2
    t.string    "cds_codes"
    t.integer   "chr_roi_start"
    t.integer   "chr_roi_stop"
    t.integer   "roi_strand",            :limit => 2
    t.integer   "chr_target_start"
    t.integer   "target_roi_start"
    t.integer   "target_roi_stop"
    t.text      "target_seq_clean"
    t.text      "target_seq_degenerate"
    t.integer   "version_id"
    t.string    "genome_build",          :limit => 25
    t.datetime  "created_at"
    t.timestamp "updated_at"
  end

  add_index "target_regions", ["gene_roi"], :name => "gene_roi_ind"

  create_table "targets", :force => true do |t|
    t.string    "gene_roi",              :limit => 50
    t.string    "gene_code",             :limit => 25
    t.integer   "roi_nr",                :limit => 2
    t.string    "cds_ids"
    t.string    "ccds_ids"
    t.string    "g_accession"
    t.string    "chr_num",               :limit => 3
    t.integer   "chr_roi_start"
    t.integer   "chr_roi_stop"
    t.integer   "roi_strand",            :limit => 2
    t.integer   "chr_target_start"
    t.integer   "target_roi_start"
    t.integer   "target_roi_stop"
    t.string    "target_seq_clean"
    t.string    "target_seq_degenerate"
    t.datetime  "created_at"
    t.timestamp "updated_at"
  end

  create_table "uploads", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "filename"
    t.string   "original_filename"
    t.string   "content_type"
    t.integer  "size"
    t.string   "upload_file"
    t.string   "sender"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "loadtodb_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
  end

  create_table "vectors", :force => true do |t|
    t.string    "description", :limit => 50
    t.string    "vector",      :limit => 75, :default => "", :null => false
    t.string    "u_vector",    :limit => 75
    t.datetime  "created_at"
    t.timestamp "updated_at"
  end

  create_table "versions", :force => true do |t|
    t.string    "version_for_synthesis", :limit => 1
    t.string    "exonome_or_partial",    :limit => 1
    t.string    "genome_build",          :limit => 15, :default => "", :null => false
    t.string    "ccds_build",            :limit => 15
    t.string    "dbsnp_build",           :limit => 15
    t.string    "design_version",        :limit => 15, :default => "", :null => false
    t.string    "version_name",          :limit => 50
    t.integer   "vector_id"
    t.string    "archive_flag",          :limit => 1
    t.string    "genome_build_notes"
    t.string    "design_version_notes"
    t.datetime  "created_at"
    t.timestamp "updated_at",                                          :null => false
  end

end
