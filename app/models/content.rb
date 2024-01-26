class Content < ApplicationRecord
  has_many :fragments, dependent: :destroy, class_name: "ContentFragment"
end
