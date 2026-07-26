# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Creating admin user..."
admin = User.find_or_initialize_by(email: "admin@example.com")
admin.first_name = "Admin"
admin.last_name = "User"
admin.role = "admin"
admin.status = "active"
admin.password = "password" if admin.new_record? || admin.encrypted_password.blank?
admin.password_confirmation = "password" if admin.new_record? || admin.encrypted_password.blank?
admin.save!

puts "Creating Cities in database..."
cities_list = [
  { name: "Mohali", state: "Punjab", image_url: "https://jantahousing.com/wp-content/uploads/2023/11/maxresdefault-2.jpg" },
  { name: "Zirakpur", state: "Punjab", image_url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSBNk50GwBiXyV73grfcaTxPyPWEKDmXb-yoy1j-G6DizGnqQR0Ad8qHLk&s=10" },
  { name: "Chandigarh", state: "Chandigarh", image_url: "https://s7ap1.scene7.com/is/image/incredibleindia/chandigarh-union-territory-1-city-ff?qlt=82&ts=1742195658178" },
  { name: "Panchkula", state: "Haryana", image_url: "https://cdn1.tripoto.com/media/filter/tst/img/1891611/Image/1653237303_img_20211020_081212_1.jpg.webp" },
  { name: "Patiala", state: "Punjab", image_url: "https://s7ap1.scene7.com/is/image/incredibleindia/moti-bagh-wildlife-sanctuary-patiala-punjab-1-attr-nearby?qlt=82&ts=1742158995286" }
]

cities_list.each do |cd|
  c = City.find_or_initialize_by(name: cd[:name])
  c.update!(state: cd[:state], image_url: cd[:image_url], active: true)
end

