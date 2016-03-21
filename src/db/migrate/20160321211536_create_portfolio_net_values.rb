class CreatePortfolioNetValues < ActiveRecord::Migration[5.0]
  def change
    create_table :portfolio_net_values do |t|
      t.belongs_to :portfolio
      t.belongs_to :currency
      t.belongs_to :asset_category, null: true
      t.decimal    :value, precision: 20, scale: 2

      t.timestamps
    end
  end
end
