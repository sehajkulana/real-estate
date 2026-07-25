class Admin::DashboardController < Admin::BaseController
  def index
    # Automatically normalize any legacy 'agent' role users to 'seller'
    User.where(role: "agent").update_all(role: "seller") rescue nil

    @stats = {
      total_properties:   Property.count,
      active_properties:  Property.where(status: "Active").count,
      pending_properties: Property.where(status: "Pending").count,
      featured_properties: Property.where(featured: true).count,
      total_users:        User.count,
      regular_users:      User.where(role: ["user", "buyer", nil]).count,
      total_sellers:      User.where(role: "seller").count,
      total_agents:       User.where(role: "seller").count,
      verified_sellers:   User.where(role: "seller", is_verified: true).count,
      verified_agents:    User.where(role: "seller", is_verified: true).count,
      total_cities:       City.count,
      active_cities:      City.where(active: true).count,
      total_inquiries:    PropertyInquiry.count,
      total_appointments: Appointment.count,
      pending_reports:    Report.where(status: ["pending", nil]).count,
      total_reports:      Report.count
    }

    @recent_properties = Property
      .includes(property_images: { image_attachment: :blob })
      .order(created_at: :desc)
      .limit(6)

    @recent_inquiries = PropertyInquiry
      .includes(:property, :buyer)
      .order(created_at: :desc)
      .limit(5)

    @recent_reports = Report
      .includes(:property, :reported_by)
      .where(status: ["pending", nil])
      .order(created_at: :desc)
      .limit(5)
  end
end
