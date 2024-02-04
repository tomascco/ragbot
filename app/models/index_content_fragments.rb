module IndexContentFragments
  extend self

  def call(content_fragments)
    ActiveRecord::Base.transaction do
      ActiveRecord::Base.connection.exec_insert(<<~SQL, "Index vectors", values(content_fragments))
        INSERT INTO vss_content_fragments (rowid, embedding)
        VALUES #{Array.new(content_fragments.size, "(?, ?)").join(", ")}
      SQL
    end
  end

  def values(content_fragments)
    content_fragments.flat_map do |content_fragment|
      [
        content_fragment[:id],
        content_fragment[:embedding].to_json
      ]
    end
  end
end
