class Admin::InquiriesController < Admin::BaseController
  def index
    @inquiries = PropertyInquiry
      .includes(:property, :buyer, :seller)
      .order(created_at: :desc)
    @inquiries = @inquiries.where(property_id: params[:property_id]) if params[:property_id].present?
    @inquiries = @inquiries.joins(:buyer).where(
      "users.first_name ILIKE ? OR users.last_name ILIKE ? OR users.email ILIKE ? OR property_inquiries.name ILIKE ?",
      "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%"
    ) if params[:q].present?
  end
end
