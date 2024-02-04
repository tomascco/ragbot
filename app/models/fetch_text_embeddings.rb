module FetchTextEmbeddings
  OPENAI_CLIENT = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY"))

  def self.call(text)
    OPENAI_CLIENT.embeddings(parameters: {
      model: "text-embedding-3-small",
      input: text
    }).dig("data", 0, "embedding")
  end
end
