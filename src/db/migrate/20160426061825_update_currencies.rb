class UpdateCurrencies < ActiveRecord::Migration[5.0]
  def change
    remove_column :currencies, :current_rate
    remove_column :currencies, :rate_cached_time
  end
end
