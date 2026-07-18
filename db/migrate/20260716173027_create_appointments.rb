class CreateAppointments < ActiveRecord::Migration[8.1]
  def change
    create_table :appointments do |t|
      t.references :property, null: false, foreign_key: true
      t.references :buyer, null: false, foreign_key: true
      t.references :seller, null: false, foreign_key: true
      t.date :appointment_date
      t.time :appointment_time
      t.text :message
      t.string :status

      t.timestamps
    end
  end
end
