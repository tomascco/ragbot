import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="answer"
export default class extends Controller {
  static targets = [ "question", "response" ]
  static values = { endpoint: String }

  create() {
    let eventSource = new EventSource(`${this.endpointValue}?question=${this.questionTarget.value}`);

    eventSource.addEventListener("answer_chunk", (event) => {
      this.responseTarget.innerText += event.data;
    });

    eventSource.addEventListener("error", (event) => {
      if (event.eventPhase === EventSource.CLOSED) {
        eventSource.close()
        console.log("Event Source Closed")
      }
    })
  }
}
