class City < ApplicationRecord
  has_one_attached :image

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :active, -> { where(active: true) }

  def display_image_url
    if image.attached?
      Rails.application.routes.url_helpers.url_for(image)
    else
      image_url.presence || "https://images.unsplash.com/photo-1571210983196-17b1ff4473de?auto=format&fit=crop&w=800&q=80"
    end
  end
end
