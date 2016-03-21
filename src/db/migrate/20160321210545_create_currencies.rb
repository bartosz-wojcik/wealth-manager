class CreateCurrencies < ActiveRecord::Migration[5.0]
  def change
    create_table :currencies do |t|
      t.string    :name
      t.decimal   :current_rate, precision: 12, scale: 4
      t.timestamp :rate_cached_time

      t.timestamps
    end
  end
end
