class CreateProperties < ActiveRecord::Migration[8.1]
  def change
    create_table :properties do |t|
      t.string :title
      t.text :description
      t.string :property_type
      t.string :listing_type
      t.decimal :price
      t.decimal :area
      t.string :area_unit
      t.integer :bedrooms
      t.integer :bathrooms
      t.integer :balconies
      t.integer :parking
      t.string :furnished
      t.string :construction_status
      t.integer :age_of_property
      t.integer :floor
      t.integer :total_floors
      t.string :facing
      t.string :ownership
      t.text :address
      t.string :city
      t.string :state
      t.string :country
      t.string :pincode
      t.decimal :latitude
      t.decimal :longitude
      t.references :seller, null: false, foreign_key: true
      t.string :status
      t.boolean :featured
      t.integer :views

      t.timestamps
    end
  end
end
