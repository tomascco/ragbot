module AskQuestion
  OPENAI_CLIENT = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY"))

  def self.call(query)
    embeddings = FetchTextEmbeddings.call(query)

    retrieved_content = Content.last.semantic_search(embeddings, limit: 10)

    formatted_content = retrieved_content.map do
      "ID: #{_1.metadata["id"]}, Author: #{_1.metadata["author"]}, Information #{_1.body}"
    end.join("\n")

    prompt = <<~PROMPT
      Answer the question based only on the information. Cite the author whose information you are using.
      The citation should be inline in the format "Author (id)". If the information comes from multiple ids
      you must still cite them all, even if it is the same author.

      #{formatted_content}

      Question:
    PROMPT

    OPENAI_CLIENT.chat(parameters: {
      model: "gpt-4",
      messages: [{ role: "system", content: prompt }, { role: "user", content: query}],
      temperature: 0
    }).dig("choices", 0, "message", "content")
  end
end
