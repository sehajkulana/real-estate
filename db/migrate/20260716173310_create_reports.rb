class CreateReports < ActiveRecord::Migration[8.1]
  def change
    create_table :reports do |t|
      t.references :property, null: false, foreign_key: true
      t.references :reported_by, null: false, foreign_key: true
      t.string :reason
      t.text :description
      t.string :status

      t.timestamps
    end
  end
end
