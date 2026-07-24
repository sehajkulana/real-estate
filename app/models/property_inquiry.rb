class PropertyInquiry < ApplicationRecord
  belongs_to :property, optional: true
  belongs_to :buyer, class_name: "User", optional: true
  belongs_to :seller, class_name: "User", optional: true

  validates :name, :email, presence: true
end
