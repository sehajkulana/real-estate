class CreatePropertyInquiries < ActiveRecord::Migration[8.1]
  def change
    create_table :property_inquiries do |t|
      t.references :property, foreign_key: true
      t.references :buyer, null: false, foreign_key: true
      t.references :seller, foreign_key: true
      t.string :name
      t.string :email
      t.string :phone
      t.text :message

      t.timestamps
    end
  end
end
