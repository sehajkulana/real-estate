class User < ApplicationRecord
  has_secure_password
  has_many :listed_properties, class_name: "Property", foreign_key: :seller_id, inverse_of: :seller
  has_one_attached :profile_picture
end
