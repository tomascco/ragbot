class Message < ApplicationRecord
  belongs_to :conversation

  has_one :user, through: :conversation
end
