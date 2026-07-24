class Admin::AppointmentsController < Admin::BaseController
  def index
    @appointments = Appointment
      .includes(:property, :buyer, :seller)
      .order(appointment_date: :desc, appointment_time: :desc)
    @appointments = @appointments.where(status: params[:status]) if params[:status].present?
  end

  def update
    @appointment = Appointment.find(params[:id])
    allowed_statuses = %w[Scheduled Confirmed Completed Cancelled]
    new_status = params.dig(:appointment, :status)

    if allowed_statuses.include?(new_status) && @appointment.update(status: new_status)
      render json: { success: true, status: @appointment.status }
    else
      render json: { success: false, errors: @appointment.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
