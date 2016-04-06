class AddCurrencyToAccount < ActiveRecord::Migration[5.0]
  def change
    add_reference :accounts, :currency, index: true, foreign_key: true, null: true
  end
end
