class Admin::CitiesController < Admin::BaseController
  before_action :set_city, only: [:edit, :update, :destroy]

  def index
    @cities = City.includes(image_attachment: :blob).order(:name)
  end

  def new
    @city = City.new
  end

  def create
    @city = City.new(city_params)
    if @city.save
      redirect_to admin_cities_path, notice: "City \"#{@city.name}\" added successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @city.update(city_params)
      redirect_to admin_cities_path, notice: "City \"#{@city.name}\" updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    name = @city.name
    @city.destroy
    redirect_to admin_cities_path, notice: "City \"#{name}\" removed."
  end

  private

  def set_city
    @city = City.find(params[:id])
  end

  def city_params
    params.require(:city).permit(:name, :state, :description, :image_url, :active, :image, :remove_image)
  end
end
