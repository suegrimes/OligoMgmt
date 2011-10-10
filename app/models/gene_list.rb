# == Schema Information
# Schema version: 20090121183010
#
# Table name: gene_lists
#
#  id              :integer(4)      not null, primary key
#  list_owner_id   :integer(4)      not null
#  list_owner_type :string(50)      default(""), not null
#  gene_code       :string(50)      default(""), not null
#  updated_by      :integer(4)
#  updated_at      :timestamp
#


class GeneList < ActiveRecord::Base
  belongs_to :list_owner, :polymorphic => true 
end
