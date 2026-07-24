class Admin::BaseController < ApplicationController
  layout "admin"
  before_action :require_admin

  private

  def require_admin
    # TODO: Replace with proper session check once authentication is built
    # current_user = User.find_by(id: session[:user_id])
    # unless current_user&.role == "admin"
    #   redirect_to root_path, alert: "Access denied."
    # end
    true
  end
end
