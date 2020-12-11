class RemoveWarehouseFromProducts < ActiveRecord::Migration[5.2]
  def change
    remove_column :products, :warehouse_id, :integer
    remove_reference :products, :warehouse_id, index: true, foreign_key: true
  end
end
