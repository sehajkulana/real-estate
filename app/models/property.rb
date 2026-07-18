class Property < ApplicationRecord
  belongs_to :seller, class_name: "User"
  has_many :property_images, dependent: :destroy
end
