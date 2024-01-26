class User < ApplicationRecord
    has_many :conversations, dependent: :destroy
    has_many :messages, through: :conversations
end
