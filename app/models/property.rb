class Property < ApplicationRecord
  belongs_to :seller, class_name: "User", inverse_of: :listed_properties, optional: true
  has_many :property_images, dependent: :destroy
  accepts_nested_attributes_for :property_images, allow_destroy: true

  scope :active_listings, -> { where("LOWER(COALESCE(properties.status, '')) != ?", "inactive") }
end
