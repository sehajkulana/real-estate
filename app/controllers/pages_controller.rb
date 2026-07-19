class PagesController < ApplicationController
  def home
    @latest_properties = Property.includes(property_images: { image_attachment: :blob })
                                 .order(created_at: :desc)
                                 .limit(3)
    @agents = User.where(role: "agent")
                  .left_joins(:listed_properties)
                  .group("users.id")
                  .order(Arel.sql("COUNT(properties.id) DESC"), :first_name, :last_name)
                  .limit(4)
                  .preload(:listed_properties)
  end

  def about; end

  def agent
    @agents = User.where(role: "agent")
                  .left_joins(:listed_properties)
                  .group("users.id")
                  .order(Arel.sql("COUNT(properties.id) DESC"), :first_name, :last_name)
                  .preload(:listed_properties)
  end

  def services; end

  def properties
    @filters = property_filter_params.to_h
    @search_city = @filters["city"].to_s.strip
    @properties = Property.includes(property_images: { image_attachment: :blob }).order(created_at: :desc)

    @properties = @properties.where("properties.city ILIKE ?", "%#{@search_city}%") if @search_city.present?
    @properties = @properties.where("properties.bathrooms >= ?", @filters["bathrooms"].to_i) if @filters["bathrooms"].present?
    @properties = apply_range_filter(@properties, :price, @filters["budget"])
    @properties = @properties.where(facing: @filters["facing"]) if @filters["facing"].present?
    @properties = @properties.where(property_type: @filters["property_type"]) if @filters["property_type"].present?
    @properties = @properties.where("properties.parking >= ?", @filters["parking"].to_i) if @filters["parking"].present?
    @properties = apply_range_filter(@properties, :area, @filters["area"])
    @properties = @properties.where(listing_type: @filters["listing_type"]) if @filters["listing_type"].present?
  end

  def property
    @property = Property.includes(property_images: { image_attachment: :blob }).find(params[:id])
  end

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

  def property_filter_params
    params.permit(:city, :bathrooms, :budget, :facing, :property_type, :parking, :area, :listing_type)
  end

  def apply_range_filter(scope, column, range)
    return scope if range.blank?

    minimum, maximum = range.split("-", 2).map(&:to_d)
    scope = scope.where("properties.#{column} >= ?", minimum)
    maximum.positive? ? scope.where("properties.#{column} <= ?", maximum) : scope
  end

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
