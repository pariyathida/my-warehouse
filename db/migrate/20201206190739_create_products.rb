class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :type
      t.string :name
      t.string :description
      t.datetime :import_date
      t.datetime :export_date
      t.integer :weight
      t.integer :width
      t.integer :length
      t.integer :height
      t.float :total_fee

      t.timestamps
    end
  end
end
