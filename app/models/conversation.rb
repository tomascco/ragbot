class Conversation < ApplicationRecord
  belongs_to :user, optional: true

  has_many :messages, dependent: :destroy
end
