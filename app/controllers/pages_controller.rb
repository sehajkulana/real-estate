class PagesController < ApplicationController
  before_action :ensure_valid_cities, only: [:home, :properties]

  def home
    @featured_properties = Property.where(featured: true)
                                   .includes(property_images: { image_attachment: :blob })
                                   .order(created_at: :desc)
                                   .limit(10)
    if @featured_properties.empty?
      @featured_properties = Property.includes(property_images: { image_attachment: :blob }).order(created_at: :desc).limit(10)
    end

    owner_user_ids = User.where(role: ["owner", "seller", "user"]).pluck(:id)
    @owner_properties = Property.where(seller_id: owner_user_ids)
                                .or(Property.where("ownership ILIKE ?", "%owner%"))
                                .includes(property_images: { image_attachment: :blob })
                                .order(created_at: :desc)
                                .limit(10)

    @latest_projects = Property.where("construction_status ILIKE ? OR construction_status ILIKE ?", "%under construction%", "%new%")
                               .or(Property.where("created_at >= ?", 90.days.ago))
                               .includes(property_images: { image_attachment: :blob })
                               .order(created_at: :desc)
                               .limit(10)

    @business_properties = Property.where("property_type ILIKE ? OR property_type ILIKE ? OR property_type ILIKE ? OR property_type ILIKE ?", "%Commercial%", "%Shop%", "%Office%", "%Industrial%")
                                   .includes(property_images: { image_attachment: :blob })
                                   .order(created_at: :desc)
                                   .limit(10)

    @agents = User.where(role: "agent")
                  .left_joins(:listed_properties)
                  .group("users.id")
                  .order(Arel.sql("COUNT(properties.id) DESC"), :first_name, :last_name)
                  .limit(3)
                  .preload(:listed_properties)

    @filters = property_filter_params.to_h.reject { |_k, v| v.blank? }
    @is_filtered = @filters.any? || params.key?(:keyword) || params[:commit].present? || params[:filter].present?

    if @is_filtered
      @search_city = @filters["city"].to_s.strip
      @keyword = @filters["keyword"].to_s.strip
      @filtered_properties = Property.includes(property_images: { image_attachment: :blob }).order(created_at: :desc)

      if @keyword.present?
        keyword_pattern = "%#{@keyword}%"
        @filtered_properties = @filtered_properties.where(
          "properties.title ILIKE :q OR properties.description ILIKE :q OR properties.city ILIKE :q OR properties.address ILIKE :q OR properties.state ILIKE :q OR properties.country ILIKE :q OR properties.property_type ILIKE :q",
          q: keyword_pattern
        )
      end
      @filtered_properties = @filtered_properties.where("properties.city ILIKE ?", "%#{@search_city}%") if @search_city.present?
      @filtered_properties = @filtered_properties.where("properties.bathrooms >= ?", @filters["bathrooms"].to_i) if @filters["bathrooms"].present?
      @filtered_properties = apply_range_filter(@filtered_properties, :price, @filters["budget"])
      @filtered_properties = @filtered_properties.where(facing: @filters["facing"]) if @filters["facing"].present?
      if @filters["property_type"].present?
        pt = @filters["property_type"].to_s.strip
        parts = pt.split("/").map(&:strip).reject(&:blank?)
        if parts.size > 1
          clause = parts.map { "properties.property_type ILIKE ?" }.join(" OR ")
          values = parts.map { |p| "%#{p}%" }
          @filtered_properties = @filtered_properties.where(clause, *values)
        else
          @filtered_properties = @filtered_properties.where("properties.property_type ILIKE ?", "%#{pt}%")
        end
      end
      @filtered_properties = @filtered_properties.where("properties.parking >= ?", @filters["parking"].to_i) if @filters["parking"].present?
      @filtered_properties = apply_range_filter(@filtered_properties, :area, @filters["area"])
      if @filters["listing_type"].present?
        lt = @filters["listing_type"].to_s.strip
        @filtered_properties = @filtered_properties.where("properties.listing_type ILIKE ?", "%#{lt}%")
      end
      @filtered_properties = @filtered_properties.limit(10)
    end

    @cities = City.active.includes(image_attachment: :blob).order(:name) if defined?(City) && ActiveRecord::Base.connection.table_exists?(:cities)
    @cities ||= []
    @available_cities = @cities.map(&:name).presence || Property.where.not(city: [nil, ""]).order(:city).pluck(:city).map(&:strip).uniq
    @placeholders = Property.where.not(city: [nil, ""]).pluck(:title, :city, :property_type).map do |title, city, ptype|
      if title.present?
        "#{title} in #{city}"
      else
        "#{ptype.presence || 'Luxury Property'} in #{city}"
      end
    end.compact_blank.uniq

    default_category_images = {
      "Apartment" => "https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=800&q=80",
      "Villa" => "https://images.unsplash.com/photo-1613977257363-707ba9348227?auto=format&fit=crop&w=800&q=80",
      "Penthouse" => "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=800&q=80",
      "Residential" => "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=800&q=80",
      "Commercial" => "https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&w=800&q=80",
      "Office Space" => "https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=800&q=80",
      "Farmhouse" => "https://images.unsplash.com/photo-1510798831971-661eb04b3739?auto=format&fit=crop&w=800&q=80",
      "Plot / Land" => "https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=800&q=80"
    }

    category_names = ["Apartment", "Villa", "Penthouse", "Residential", "Commercial", "Office Space", "Farmhouse", "Plot / Land"]
    @property_type_categories = category_names.map do |type_name|
      parts = type_name.split("/").map(&:strip).reject(&:blank?)
      query_scope = if parts.size > 1
                      clause = parts.map { "property_type ILIKE ?" }.join(" OR ")
                      values = parts.map { |p| "%#{p}%" }
                      Property.where(clause, *values)
                    else
                      Property.where("property_type ILIKE ?", "%#{type_name}%")
                    end

      prop = query_scope.includes(property_images: { image_attachment: :blob }).first
      img_url = nil
      if prop&.property_images&.first&.image&.attached?
        img_url = helpers.url_for(prop.property_images.first.image)
      elsif prop&.property_images&.first&.image_url.present?
        img_url = prop.property_images.first.image_url
      end
      img_url ||= default_category_images[type_name]
      count = query_scope.count

      {
        name: type_name,
        image_url: img_url,
        count: count
      }
    end
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
    @keyword = @filters["keyword"].to_s.strip
    @properties = Property.includes(property_images: { image_attachment: :blob }).order(created_at: :desc)

    if params[:featured] == "true"
      @properties = @properties.where(featured: true).or(@properties.where("views > 0"))
    end

    if params[:owner] == "true"
      owner_user_ids = User.where(role: ["owner", "seller", "user"]).pluck(:id)
      @properties = @properties.where(seller_id: owner_user_ids).or(@properties.where("ownership ILIKE ?", "%owner%"))
    end

    if params[:section] == "latest_projects"
      @properties = @properties.where("construction_status ILIKE ? OR construction_status ILIKE ?", "%under construction%", "%new%")
                               .or(@properties.where("created_at >= ?", 90.days.ago))
    elsif params[:section] == "business_for_sale"
      @properties = @properties.where("property_type ILIKE ? OR property_type ILIKE ? OR property_type ILIKE ? OR property_type ILIKE ?", "%Commercial%", "%Shop%", "%Office%", "%Industrial%")
    end

    if @keyword.present?
      keyword_pattern = "%#{@keyword}%"
      @properties = @properties.where(
        "properties.title ILIKE :q OR properties.description ILIKE :q OR properties.city ILIKE :q OR properties.address ILIKE :q OR properties.state ILIKE :q OR properties.country ILIKE :q OR properties.property_type ILIKE :q",
        q: keyword_pattern
      )
    end
    @properties = @properties.where("properties.city ILIKE ?", "%#{@search_city}%") if @search_city.present?
    @properties = @properties.where("properties.bathrooms >= ?", @filters["bathrooms"].to_i) if @filters["bathrooms"].present?
    @properties = apply_range_filter(@properties, :price, @filters["budget"])
    @properties = @properties.where(facing: @filters["facing"]) if @filters["facing"].present?
    if @filters["property_type"].present?
      pt = @filters["property_type"].to_s.strip
      parts = pt.split("/").map(&:strip).reject(&:blank?)
      if parts.size > 1
        clause = parts.map { "properties.property_type ILIKE ?" }.join(" OR ")
        values = parts.map { |p| "%#{p}%" }
        @properties = @properties.where(clause, *values)
      else
        @properties = @properties.where("properties.property_type ILIKE ?", "%#{pt}%")
      end
    end
    @properties = @properties.where("properties.parking >= ?", @filters["parking"].to_i) if @filters["parking"].present?
    @properties = apply_range_filter(@properties, :area, @filters["area"])
    if @filters["listing_type"].present?
      lt = @filters["listing_type"].to_s.strip
      @properties = @properties.where("properties.listing_type ILIKE ?", "%#{lt}%")
    end
    @available_cities = Property.where.not(city: [nil, ""]).order(:city).pluck(:city).map(&:strip).uniq
    @placeholders = Property.where.not(city: [nil, ""]).pluck(:title, :city, :property_type).map do |title, city, ptype|
      if title.present?
        "#{title} in #{city}"
      else
        "#{ptype.presence || 'Luxury Property'} in #{city}"
      end
    end.compact_blank.uniq

    @properties = @properties.limit(24)
  end

  def autocomplete_properties
    query = params[:q].to_s.strip
    results = []

    if query.length >= 2
      keyword_pattern = "%#{query}%"
      properties = Property.where(
        "properties.title ILIKE :q OR properties.city ILIKE :q OR properties.address ILIKE :q OR properties.state ILIKE :q OR properties.property_type ILIKE :q",
        q: keyword_pattern
      ).select(:id, :title, :city, :property_type, :price, :listing_type).limit(8)

      results = properties.map do |p|
        {
          id: p.id,
          title: p.title,
          city: p.city,
          property_type: p.property_type,
          price: p.price.to_i,
          listing_type: p.listing_type
        }
      end
    end

    render json: results
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
    if @property.seller_id.blank?
      default_seller = User.find_by(role: "agent") || User.first || User.create!(first_name: "Admin", last_name: "User", email: "admin@dua.com", password: "password", role: "agent")
      @property.seller = default_seller
    end

    if save_property_with_images
      redirect_to admin_path, notice: "Property was added successfully."
    else
      @sellers = User.where(role: "agent").order(:first_name, :last_name)
      error_msg = @property.errors.full_messages.presence&.join(", ") || "Could not save property. Please check all required fields."
      flash.now[:alert] = "Error: #{error_msg}"
      render :admin, status: :unprocessable_entity
    end
  end

  private

  def ensure_valid_cities
    return unless defined?(City) && ActiveRecord::Base.connection.table_exists?(:cities)

    default_cities = [
      { name: "Mohali", state: "Punjab", image_url: "https://images.unsplash.com/photo-1571210983196-17b1ff4473de?auto=format&fit=crop&w=800&q=80" },
      { name: "Zirakpur", state: "Punjab", image_url: "https://images.unsplash.com/photo-1627883391295-8833f4a9b2b2?auto=format&fit=crop&w=800&q=80" },
      { name: "Chandigarh", state: "Chandigarh", image_url: "https://images.unsplash.com/photo-1596176530529-78163a4f7af2?auto=format&fit=crop&w=800&q=80" },
      { name: "Panchkula", state: "Haryana", image_url: "https://images.unsplash.com/photo-1542361345-89ce58f625d9?auto=format&fit=crop&w=800&q=80" },
      { name: "Patiala", state: "Punjab", image_url: "https://images.unsplash.com/photo-1587474260584-136574528ed5?auto=format&fit=crop&w=800&q=80" }
    ]

    default_cities.each do |cd|
      c = City.find_or_initialize_by(name: cd[:name])
      c.state ||= cd[:state]
      c.image_url ||= cd[:image_url]
      c.active = true
      c.save if c.new_record? || c.changed?
    end

    valid_cities = City.active.pluck(:name)
    invalid_props = Property.where.not(city: valid_cities).or(Property.where(city: nil))
    if invalid_props.exists? && valid_cities.any?
      invalid_props.each_with_index do |prop, idx|
        prop.update_columns(city: valid_cities[idx % valid_cities.length])
      end
    end
  end

  def property_filter_params
    params.permit(:city, :bathrooms, :budget, :facing, :property_type, :parking, :area, :listing_type, :keyword, :filter)
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
      :featured, :status, :views, :description, :address, :city, :state, :country, :pincode,
      :latitude, :longitude
    )
  end

  def save_property_with_images
    Property.transaction do
      @property.save!

      uploaded_images.each_with_index do |uploaded_image, index|
        property_image = @property.property_images.build(is_cover: index.zero?)
        if uploaded_image.respond_to?(:read) || uploaded_image.is_a?(ActionDispatch::Http::UploadedFile)
          property_image.image.attach(uploaded_image)
        elsif uploaded_image.is_a?(String) && uploaded_image.start_with?("http", "/", "data:")
          property_image.image_url = uploaded_image
        end
        property_image.save!
      end
    end

    true
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Property creation invalid: #{e.message}")
    @property.errors.add(:base, e.message)
    false
  rescue StandardError => e
    Rails.logger.error("Property creation error: #{e.message}")
    @property.errors.add(:base, e.message)
    false
  end

  def uploaded_images
    Array(params.dig(:property, :images)).reject(&:blank?)
  end
end
