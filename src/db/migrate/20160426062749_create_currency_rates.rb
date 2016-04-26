class CreateCurrencyRates < ActiveRecord::Migration[5.0]
  def change
    create_table :currency_rates do |t|
      t.string    :pair_name
      t.integer   :base_currency_id
      t.integer   :quote_currency_id
      t.decimal   :current_rate, precision: 12, scale: 4
      t.timestamp :rate_cached_time

      t.timestamps
    end

    add_foreign_key :currency_rates, :currencies, column: :base_currency_id, primary_key: :id
    add_foreign_key :currency_rates, :currencies, column: :quote_currency_id, primary_key: :id
  end
end
