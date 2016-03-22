class AddAccountToAssetCategory < ActiveRecord::Migration[5.0]
  def change
    add_column :asset_categories, :account_id, :integer, index: true, after: :asset_type_id, default: nil
  end
end
