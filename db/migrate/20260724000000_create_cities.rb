class CreateCities < ActiveRecord::Migration[7.1]
  def change
    create_table :cities do |t|
      t.string :name, null: false
      t.string :state
      t.string :image_url
      t.text :description
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :cities, :name, unique: true
  end
end
