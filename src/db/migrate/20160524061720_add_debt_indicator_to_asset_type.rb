class AddDebtIndicatorToAssetType < ActiveRecord::Migration[5.0]
  def change
    add_column :asset_types, :is_debt, :boolean, after: :description, default: false
  end
end
