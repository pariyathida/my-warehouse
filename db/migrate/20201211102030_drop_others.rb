class DropOthers < ActiveRecord::Migration[5.2]
  def change
    drop_table :others
  end
end
