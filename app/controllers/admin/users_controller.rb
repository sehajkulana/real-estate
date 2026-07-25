class Admin::UsersController < Admin::BaseController
  def index
    User.where(role: "agent").update_all(role: "seller") rescue nil
    @users = User.order(created_at: :desc)
    @users = @users.where(role: params[:role]) if params[:role].present?
    @users = @users.where("first_name ILIKE ? OR last_name ILIKE ? OR email ILIKE ?",
      "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%") if params[:q].present?

    @total_counts = {
      all:    User.count,
      admin:  User.where(role: "admin").count,
      seller: User.where(role: "seller").count,
      user:   User.where(role: ["user", "buyer", nil]).count
    }
  end

  def update
    @user = User.find(params[:id])
    user_params = params.require(:user)
    attrs = {}
    attrs[:role] = user_params[:role] if user_params.key?("role") || user_params.key?(:role)
    attrs[:status] = user_params[:status] if user_params.key?("status") || user_params.key?(:status)
    attrs[:is_verified] = user_params[:is_verified] if user_params.key?("is_verified") || user_params.key?(:is_verified)

    if @user.update(attrs)
      render json: {
        success: true,
        role: @user.role,
        status: @user.status,
        is_verified: @user.is_verified
      }
    else
      render json: { success: false, errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
