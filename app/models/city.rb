class City < ApplicationRecord
  has_one_attached :image

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :active, -> { where(active: true) }

  attr_accessor :remove_image
  after_save :purge_image, if: -> { remove_image == '1' || remove_image == true }

  def display_image_url
    if image.attached?
      Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true)
    else
      image_url.presence || "https://images.unsplash.com/photo-1571210983196-17b1ff4473de?auto=format&fit=crop&w=800&q=80"
    end
  end

  private

  def purge_image
    image.purge_later if image.attached?
  end
end
