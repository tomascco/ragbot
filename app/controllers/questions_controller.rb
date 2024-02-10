class QuestionsController < ApplicationController
  include ActionController::Live

  def index
  end

  def answer
    response.headers['Content-Type'] = 'text/event-stream'

    sse = SSE.new(response.stream, event: "answer_chunk")

    stream = proc do |chunk, _bytesize|
      part = chunk.dig("choices", 0, "delta", "content")
      sse.write(part) if part.present?
    end

    AskQuestion.call(params[:question], stream:)
  ensure
    sse&.close
  end
end
