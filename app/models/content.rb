class Content < ApplicationRecord
  has_many :fragments, dependent: :destroy, class_name: "ContentFragment"

  def semantic_search(embedding, limit: 5)
    vector_search = ContentFragmentIndex
      .select(:rowid)
      .where("vss_search(embedding, ?)", embedding.to_json)
      .limit(limit)

    ContentFragment
      .where(content: self)
      .where(id: vector_search)
  end
end
