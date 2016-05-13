class AddDateToCurrencyRates < ActiveRecord::Migration[5.0]
  def change
    add_column :currency_rates, :rate_date, :date, after: :current_rate
  end
end
