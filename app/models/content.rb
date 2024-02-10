class Content < ApplicationRecord
  has_many :fragments, dependent: :destroy, class_name: "ContentFragment"

  def semantic_search(embedding, limit: 5, distance: 1)
    vector_search = ContentFragmentIndex
      .select(:rowid)
      .where("vss_search(embedding, ?)", embedding.to_json)
      .where("distance < ?", distance)
      .limit(limit)
      .order("distance ASC")

    ContentFragment
      .where(content: self)
      .where(id: vector_search)
  end
end
