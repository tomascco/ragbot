class ContentFragment < ApplicationRecord
  include AASM

  belongs_to :content
  has_one :index,
    class_name: "ContentFragmentIndex",
    primary_key: "id",
    foreign_key: "rowid",
    dependent: :destroy

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
