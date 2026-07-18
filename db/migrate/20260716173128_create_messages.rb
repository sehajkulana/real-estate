class CreateMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :messages do |t|
      t.references :sender, null: false, foreign_key: true
      t.references :receiver, null: false, foreign_key: true
      t.references :property, null: false, foreign_key: true
      t.text :message
      t.boolean :is_read

      t.timestamps
    end
  end
end
