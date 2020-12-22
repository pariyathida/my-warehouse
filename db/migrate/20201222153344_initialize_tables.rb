class InitializeTables < ActiveRecord::Migration[5.2]
  def change
    create_table :parcels do |t|
      t.datetime :import_date
      t.datetime :export_date
      t.integer :weight
      t.integer :width
      t.integer :length
      t.integer :height
      t.boolean :in_stock

      t.timestamps
    end

    create_table :parcel_types do |t|
      t.string :name
      t.boolean :calculate_by_weight
      t.boolean :calculate_by_dimension
      t.boolean :double_rate_each_day
      t.float :fee_rate
      t.float :weight_conversion
      t.float :dimension_conversion
      t.string :currency

      t.timestamps
    end
  end
end
