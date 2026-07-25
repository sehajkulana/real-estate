# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Creating seller user..."
seller = User.find_or_create_by!(email: "seller@example.com") do |u|
  u.password_digest = "secret"
  u.first_name = "Luxury"
  u.last_name = "Agent"
  u.role = "seller"
  u.status = "active"
end

puts "Creating agent user..."
agent = User.find_or_create_by!(email: "agent@example.com") do |u|
  u.password_digest = "secret"
  u.first_name = "Premier"
  u.last_name = "Broker"
  u.role = "agent"
  u.status = "active"
end

puts "Creating 10 unique properties..."

properties_data = [
  {
    title: "Skyline Penthouse with Panoramic Views",
    description: "Experience luxury living in this stunning penthouse offering 360-degree views of the city. Features floor-to-ceiling windows, private elevator access, and a smart home system.",
    address: "123 Horizon Tower, Sector 70",
    city: "Mohali",
    state: "Punjab",
    country: "India",
    pincode: "160071",
    price: 85000000,
    area: 4500,
    area_unit: "sq ft",
    bedrooms: 4,
    bathrooms: 5,
    balconies: 3,
    property_type: "Penthouse",
    listing_type: "Sale",
    featured: true
  },
  {
    title: "Tranquil Luxury Villa in Sector 8",
    description: "A gorgeous luxury villa located in the heart of Chandigarh. Features private garden, swimming pool, and modern architecture.",
    address: "45 Palm Drive, Sector 8",
    city: "Chandigarh",
    state: "Chandigarh",
    country: "India",
    pincode: "160008",
    price: 45000000,
    area: 6000,
    area_unit: "sq ft",
    bedrooms: 5,
    bathrooms: 6,
    balconies: 4,
    property_type: "Villa",
    listing_type: "Sale",
    featured: true
  },
  {
    title: "Modern Minimalist Apartment",
    description: "Sleek and stylish 3-bedroom apartment located in Zirakpur. Close to VIP Road, shopping malls, and top restaurants.",
    address: "Apt 204, VIP Road Enclave",
    city: "Zirakpur",
    state: "Punjab",
    country: "India",
    pincode: "140603",
    price: 25000000,
    area: 2100,
    area_unit: "sq ft",
    bedrooms: 3,
    bathrooms: 3,
    balconies: 2,
    property_type: "Apartment",
    listing_type: "Sale",
    featured: false
  },
  {
    title: "Heritage Royal Bungalow",
    description: "A meticulously crafted bungalow in Panchkula featuring wooden flooring, high ceilings, and sprawling private lawns.",
    address: "78 Sector 6 Estate",
    city: "Panchkula",
    state: "Haryana",
    country: "India",
    pincode: "134109",
    price: 120000000,
    area: 8500,
    area_unit: "sq ft",
    bedrooms: 6,
    bathrooms: 5,
    balconies: 2,
    property_type: "Villa",
    listing_type: "Sale",
    featured: true
  },
  {
    title: "Premium Commercial Office Space",
    description: "Fully furnished, plug-and-play office space in a Grade A commercial building in Patiala. Features modern conference rooms.",
    address: "Floor 3, Mall Road Business Hub",
    city: "Patiala",
    state: "Punjab",
    country: "India",
    pincode: "147001",
    price: 1500000,
    area: 3200,
    area_unit: "sq ft",
    bedrooms: 0,
    bathrooms: 4,
    balconies: 1,
    property_type: "Office Space",
    listing_type: "Rent",
    featured: false
  },
  {
    title: "Cozy Studio Apartment for Rent",
    description: "Perfect for young professionals, this studio apartment in Sector 68 comes fully furnished with modern amenities.",
    address: "501 Azure Residences, Sector 68",
    city: "Mohali",
    state: "Punjab",
    country: "India",
    pincode: "160062",
    price: 35000,
    area: 600,
    area_unit: "sq ft",
    bedrooms: 1,
    bathrooms: 1,
    balconies: 1,
    property_type: "Apartment",
    listing_type: "Rent",
    featured: false
  },
  {
    title: "Luxury Duplex in Gated Community",
    description: "Spacious duplex with premium fittings, private garden, and home theater in Chandigarh. Located in a secure green neighborhood.",
    address: "Villa 14, Sector 33",
    city: "Chandigarh",
    state: "Chandigarh",
    country: "India",
    pincode: "160032",
    price: 65000000,
    area: 4200,
    area_unit: "sq ft",
    bedrooms: 4,
    bathrooms: 4,
    balconies: 3,
    property_type: "Villa",
    listing_type: "Sale",
    featured: false
  },
  {
    title: "High-Street Retail Shop on Chandigarh Road",
    description: "Prime retail space in Zirakpur located on a busy high street with excellent visibility and heavy footfall.",
    address: "Shop 4, Chandigarh-Ambala Highway",
    city: "Zirakpur",
    state: "Punjab",
    country: "India",
    pincode: "140603",
    price: 450000,
    area: 1200,
    area_unit: "sq ft",
    bedrooms: 0,
    bathrooms: 1,
    balconies: 0,
    property_type: "Shop / Retail",
    listing_type: "Rent",
    featured: true
  },
  {
    title: "Lush Green Farmhouse in Panchkula",
    description: "Escape to this beautiful farmhouse surrounded by lush greenery in Sector 24. Features private pool and organic garden.",
    address: "Plot 88, Green Acres, Sector 24",
    city: "Panchkula",
    state: "Haryana",
    country: "India",
    pincode: "134116",
    price: 90000000,
    area: 15000,
    area_unit: "sq ft",
    bedrooms: 5,
    bathrooms: 6,
    balconies: 4,
    property_type: "Farmhouse",
    listing_type: "Sale",
    featured: false
  },
  {
    title: "Boutique Apartment with Terrace",
    description: "A beautifully designed 2-bedroom apartment featuring a private terrace in Patiala. Located in an upscale residential area.",
    address: "402 Urban Estate, Phase 2",
    city: "Patiala",
    state: "Punjab",
    country: "India",
    pincode: "147002",
    price: 18000000,
    area: 1500,
    area_unit: "sq ft",
    bedrooms: 2,
    bathrooms: 2,
    balconies: 1,
    property_type: "Apartment",
    listing_type: "Sale",
    featured: false
  }
]

properties_data.each_with_index do |data, index|
  prop = Property.find_or_create_by!(title: data[:title]) do |p|
    p.description = data[:description]
    p.address = data[:address]
    p.city = data[:city]
    p.state = data[:state]
    p.country = data[:country]
    p.pincode = data[:pincode]
    p.price = data[:price]
    p.area = data[:area]
    p.area_unit = data[:area_unit]
    p.bedrooms = data[:bedrooms]
    p.bathrooms = data[:bathrooms]
    p.balconies = data[:balconies]
    p.property_type = data[:property_type]
    p.listing_type = data[:listing_type]
    p.featured = data[:featured]
    p.seller = seller
  end

  # Array of gorgeous real estate images from Unsplash to use as placeholders
  image_placeholders = [
    "https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=800&q=80",
    "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=800&q=80",
    "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=800&q=80",
    "https://images.unsplash.com/photo-1600607687931-cebf10cb8cb0?auto=format&fit=crop&w=800&q=80",
    "https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?auto=format&fit=crop&w=800&q=80",
    "https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=800&q=80",
    "https://images.unsplash.com/photo-1600121848594-d8644e57abab?auto=format&fit=crop&w=800&q=80",
    "https://images.unsplash.com/photo-1600573472550-8090b5e0745e?auto=format&fit=crop&w=800&q=80",
    "https://images.unsplash.com/photo-1600585152220-90363fe7e115?auto=format&fit=crop&w=800&q=80",
    "https://images.unsplash.com/photo-1600607688969-a5bfcd64bd19?auto=format&fit=crop&w=800&q=80"
  ]

  if prop.property_images.empty?
    PropertyImage.create!(
      property: prop,
      image_url: image_placeholders[index % image_placeholders.length],
      is_cover: true
    )
  end
end

puts "Creating Cities in database..."
cities_list = [
  { name: "Mohali", state: "Punjab", image_url: "https://images.unsplash.com/photo-1571210983196-17b1ff4473de?auto=format&fit=crop&w=800&q=80" },
  { name: "Zirakpur", state: "Punjab", image_url: "https://images.unsplash.com/photo-1627883391295-8833f4a9b2b2?auto=format&fit=crop&w=800&q=80" },
  { name: "Chandigarh", state: "Chandigarh", image_url: "https://images.unsplash.com/photo-1596176530529-78163a4f7af2?auto=format&fit=crop&w=800&q=80" },
  { name: "Panchkula", state: "Haryana", image_url: "https://images.unsplash.com/photo-1542361345-89ce58f625d9?auto=format&fit=crop&w=800&q=80" },
  { name: "Patiala", state: "Punjab", image_url: "https://images.unsplash.com/photo-1587474260584-136574528ed5?auto=format&fit=crop&w=800&q=80" }
]

cities_list.each do |cd|
  c = City.find_or_initialize_by(name: cd[:name])
  c.update!(state: cd[:state], image_url: cd[:image_url], active: true)
end

puts "Finished seeding 10 properties and cities with images!"
