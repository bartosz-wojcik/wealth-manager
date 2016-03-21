class CreatePortfolioChanges < ActiveRecord::Migration[5.0]
  def change
    create_table :portfolio_changes do |t|
      t.belongs_to :portfolio
      t.belongs_to :currency
      t.belongs_to :asset_category
      t.decimal    :value, precision: 20, scale: 2
      t.date       :entered_date
      t.text       :notes
      t.boolean    :partial_value, default: true

      t.timestamps
    end
  end
end
