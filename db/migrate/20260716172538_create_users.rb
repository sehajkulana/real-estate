class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :password_digest
      t.string :role
      t.string :profile_image
      t.text :address
      t.string :city
      t.string :state
      t.string :country
      t.string :pincode
      t.boolean :is_verified
      t.string :status

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
