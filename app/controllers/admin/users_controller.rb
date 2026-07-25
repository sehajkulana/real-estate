class Admin::UsersController < Admin::BaseController
  def index
    @users = User.order(created_at: :desc)
    @users = @users.where(role: params[:role]) if params[:role].present?
    @users = @users.where("first_name ILIKE ? OR last_name ILIKE ? OR email ILIKE ?",
      "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%") if params[:q].present?

    @total_counts = {
      all:    User.count,
      admin:  User.where(role: "admin").count,
      agent:  User.where(role: "agent").count,
      seller: User.where(role: "seller").count,
      user:   User.where(role: ["user", "buyer", nil]).count
    }
  end

  def update
    @user = User.find(params[:id])
    allowed_params = params.require(:user).permit(:status, :is_verified)
    allowed_params[:role] = params[:user][:role] if params[:user].key?(:role)
    if @user.update(allowed_params)
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
