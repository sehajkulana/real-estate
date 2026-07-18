class PagesController < ApplicationController
  def home
    @latest_properties = Property.includes(property_images: { image_attachment: :blob })
                                 .order(created_at: :desc)
                                 .limit(3)
  end

  def about; end

  def agent; end

  def services; end

  def properties; end

  def property; end

  def blog; end

  def blog_post; end

  def contact; end
  def admin
    @property = Property.new
    @sellers = User.where(role: "agent").order(:first_name, :last_name)
  end

  def create_property
    @property = Property.new(property_params)

    if save_property_with_images
      redirect_to admin_path, notice: "Property was added successfully."
    else
      @sellers = User.where(role: "agent").order(:first_name, :last_name)
      flash.now[:alert] = "Please correct the errors below."
      render :admin, status: :unprocessable_entity
    end
  end

  private

  def property_params
    params.require(:property).permit(
      :seller_id, :title, :listing_type, :property_type, :price, :area, :area_unit,
      :bedrooms, :bathrooms, :balconies, :parking, :age_of_property, :construction_status,
      :facing, :floor, :total_floors, :furnished, :ownership,
      :featured, :status, :views, :description, :address, :city, :state, :country, :pincode
    )
  end

  def save_property_with_images
    Property.transaction do
      @property.save!

      uploaded_images.each_with_index do |uploaded_image, index|
        property_image = @property.property_images.build(is_cover: index.zero?)
        property_image.image.attach(uploaded_image)
        property_image.save!
      end
    end

    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def uploaded_images
    Array(params.dig(:property, :images)).reject(&:blank?)
  end
end
