class CreatePropertyImages < ActiveRecord::Migration[8.1]
  def change
    create_table :property_images do |t|
      t.references :property, null: false, foreign_key: true
      t.string :image_url
      t.boolean :is_cover

      t.timestamps
    end
  end
end
