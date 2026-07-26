class User < ApplicationRecord
  has_many :listed_properties, class_name: "Property", foreign_key: :seller_id, inverse_of: :seller
  has_one_attached :profile_picture
  devise :database_authenticatable,
        :registerable,
        :recoverable,
        :rememberable,
        :validatable
end
