class AddCurrencyDescription < ActiveRecord::Migration[5.0]
  def change
    add_column :currencies, :description, :string, after: :name
  end
end
