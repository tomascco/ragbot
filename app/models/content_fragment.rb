class ContentFragment < ApplicationRecord
  include AASM

  belongs_to :content

  aasm do
    state :enqueued, initial: true
    state :processing, :processed

    event :start_process do
      transitions from: :enqueued, to: :processing
    end

    event :finish_process do
      transitions from: :processing, to: :processed
    end
  end
end
