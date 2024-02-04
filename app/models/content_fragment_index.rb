class ContentFragmentIndex < ApplicationRecord
  self.table_name = "vss_content_fragments"
  self.primary_key = "rowid"

  belongs_to :fragment, class_name: "ContentFragment", inverse_of: :index, foreign_key: "rowid"

  default_scope { select(:rowid) }
end
