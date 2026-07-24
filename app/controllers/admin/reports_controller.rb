class Admin::ReportsController < Admin::BaseController
  def index
    @reports = Report
      .includes(:property, :reported_by)
      .order(created_at: :desc)
    @reports = @reports.where(status: params[:status]) if params[:status].present?
    @reports = @reports.where(status: ["pending", nil]) if params[:status] == "pending" || !params[:status].present?
    # Show all if explicitly requesting all
    @reports = Report.includes(:property, :reported_by).order(created_at: :desc) if params[:all].present?
  end

  def update
    @report = Report.find(params[:id])
    new_status = params.dig(:report, :status)
    allowed = %w[pending reviewed dismissed resolved]

    if allowed.include?(new_status) && @report.update(status: new_status)
      redirect_to admin_reports_path, notice: "Report marked as #{new_status}."
    else
      redirect_to admin_reports_path, alert: "Could not update report."
    end
  end

  def destroy
    @report = Report.find(params[:id])
    @report.destroy
    redirect_to admin_reports_path, notice: "Report dismissed and deleted."
  end
end
