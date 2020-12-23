class Supplier < ApplicationRecord
  def all_stocks
    Stock.all
  end
end
