class CreateNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.string :notification_type
      t.boolean :is_read

      t.timestamps
    end
  end
end
