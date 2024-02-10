module AskQuestion
  OPENAI_CLIENT = OpenAI::Client.new(
    uri_base: "https://api.fireworks.ai/inference",
    access_token: ENV.fetch("FIREWORKS_API_KEY")
  )

  def self.call(query)
    embeddings = FetchTextEmbeddings.call(query)

    retrieved_content = Content.last.semantic_search(embeddings, limit: 5)

    formatted_content = retrieved_content.map do
      "ID: #{_1.metadata["id"]}, Autor: #{_1.metadata["author"]}, Informação: #{_1.body}"
    end.join("\n")

    puts formatted_content

    prompt = <<~PROMPT
      [INST]
      Sua tarefa é responder a pergunta abaixo somente com base no conteúdo fornecido.
      Por favor, forneça uma resposta clara e concisa. Cite suas fontes a seguinte formatação: (Autor, ID).
      Use somente o conteúdo relevante para responder a pergunta.
      Coloque as referências somente durante o texto da resposta.

      #{formatted_content}

      Pergunta:

      [/INST]
    PROMPT

    OPENAI_CLIENT.chat(parameters: {
      model: "accounts/fireworks/models/mixtral-8x7b-instruct",
      messages: [{ role: "system", content: prompt }, { role: "user", content: query}],
      temperature: 0,
      max_tokens: 1000
    }).dig("choices", 0, "message", "content")
  end
end
