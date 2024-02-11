class Content < ApplicationRecord
  has_many :fragments, dependent: :destroy, class_name: "ContentFragment"

  def semantic_search(embedding, limit: 5, distance: 1)
    vector_search = <<~SQL
      SELECT rowid
      FROM vss_content_fragments
      WHERE vss_search(embedding, x'#{embedding.pack("F*").unpack1("H*")}')
      AND distance < #{distance}
      ORDER BY distance ASC
      LIMIT #{limit}
    SQL

    ContentFragment
      .where(content: self)
      .where("id IN (#{vector_search})")
  end
end
