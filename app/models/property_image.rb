class PropertyImage < ApplicationRecord
  belongs_to :property
  has_one_attached :image

  validate :image_is_supported

  private

  def image_is_supported
    unless image.attached?
      errors.add(:image, "must be attached")
      return
    end

    return if image.content_type.in?(%w[image/jpeg image/png image/webp])

    errors.add(:image, "must be a JPG, PNG, or WebP file")
  end
end
