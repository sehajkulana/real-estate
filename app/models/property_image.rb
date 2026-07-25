class PropertyImage < ApplicationRecord
  belongs_to :property
  has_one_attached :image

  validate :image_is_supported, if: -> { image.attached? }

  private

  def image_is_supported
    return unless image.attached?

    allowed_types = %w[image/jpeg image/jpg image/pjpeg image/png image/webp image/gif image/avif image/svg+xml]
    unless image.content_type.to_s.downcase.in?(allowed_types)
      errors.add(:image, "must be a JPG, PNG, GIF, WebP, or AVIF file")
    end
  end
end
