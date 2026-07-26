class Admin::BaseController < ApplicationController
  layout "admin"
  before_action :authenticate_user!
  before_action :require_admin

  private

  def require_admin
    return if current_user&.role == "admin"

    redirect_to root_path, alert: "Access denied. Admin privileges required."
  end
end
