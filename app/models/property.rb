class Property < ApplicationRecord
  belongs_to :seller, class_name: "User", inverse_of: :listed_properties
  has_many :property_images, dependent: :destroy
end
