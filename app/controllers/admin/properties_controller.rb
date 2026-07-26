class Admin::PropertiesController < Admin::BaseController
  before_action :set_property, only: [:edit, :update, :destroy, :toggle_featured, :toggle_status]

  def index
    @properties = Property
      .includes(:seller, property_images: { image_attachment: :blob })
      .order(created_at: :desc)

    @properties = @properties.where("title ILIKE ? OR city ILIKE ? OR address ILIKE ?",
      "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%") if params[:q].present?
    @properties = @properties.where(status: params[:status]) if params[:status].present?
    @properties = @properties.where(property_type: params[:property_type]) if params[:property_type].present?
    @properties = @properties.where(listing_type: params[:listing_type]) if params[:listing_type].present?
  end

  def new
    @property = Property.new
    @sellers = User.where(role: "seller").order(:first_name, :last_name)
    @amenities = Amenity.order(:name)
  end

  def create
    @property = Property.new(property_params)

    if @property.seller_id.blank?
      default_seller = User.find_by(role: "seller") || User.first ||
        User.create!(first_name: "Admin", last_name: "User",
                     email: "admin@dua.com", password: "password", role: "seller")
      @property.seller = default_seller
    end

    if save_property_with_images
      redirect_to admin_properties_path, notice: "Property \"#{@property.title}\" was created successfully."
    else
      @sellers = User.where(role: "seller").order(:first_name, :last_name)
      @amenities = Amenity.order(:name)
      error_msg = @property.errors.full_messages.join(", ").presence || "Could not save property."
      flash.now[:alert] = "Error: #{error_msg}"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @sellers = User.where(role: "seller").order(:first_name, :last_name)
    @amenities = Amenity.order(:name)
  end

  def update
    @property.assign_attributes(property_params)
    if save_property_with_images
      redirect_to admin_properties_path, notice: "Property updated successfully."
    else
      @sellers = User.where(role: "seller").order(:first_name, :last_name)
      @amenities = Amenity.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    title = @property.title
    @property.destroy
    redirect_to admin_properties_path, notice: "Property \"#{title}\" deleted."
  end

  def toggle_featured
    @property.update!(featured: !@property.featured)
    render json: { featured: @property.featured }
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def toggle_status
    new_status = params[:status]
    allowed = %w[Active Pending Sold Inactive]
    if allowed.include?(new_status)
      @property.update!(status: new_status)
      render json: { status: @property.status }
    else
      render json: { error: "Invalid status" }, status: :unprocessable_entity
    end
  end

  private

  def set_property
    @property = Property.find(params[:id])
  end

  def property_params
    params.require(:property).permit(
      :seller_id, :title, :listing_type, :property_type, :price, :area, :area_unit,
      :bedrooms, :bathrooms, :balconies, :parking, :age_of_property, :construction_status,
      :facing, :floor, :total_floors, :furnished, :ownership,
      :featured, :status, :views, :description, :address, :city, :state, :country, :pincode,
      :latitude, :longitude, property_images_attributes: [:id, :_destroy]
    )
  end

  def save_property_with_images
    Property.transaction do
      @property.save!
      uploaded_images.each_with_index do |img, idx|
        is_first = @property.property_images.reject(&:new_record?).none?(&:is_cover?) && idx.zero?
        pi = @property.property_images.build(is_cover: is_first)
        if img.respond_to?(:read) || img.is_a?(ActionDispatch::Http::UploadedFile)
          pi.image.attach(img)
        elsif img.is_a?(String) && img.start_with?("http", "/", "data:")
          pi.image_url = img
        end
        pi.save!
      end
    end
    true
  rescue ActiveRecord::RecordInvalid => e
    @property.errors.add(:base, e.message)
    false
  rescue StandardError => e
    @property.errors.add(:base, e.message)
    false
  end

  def uploaded_images
    Array(params.dig(:property, :images)).reject(&:blank?)
  end
end
