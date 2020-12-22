class DropProducts < ActiveRecord::Migration[5.2]
  def down
    drop_table :products
  end
end
