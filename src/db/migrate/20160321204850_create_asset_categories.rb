class CreateAssetCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :asset_categories do |t|
      t.belongs_to :asset_type
      t.string     :name
      t.text       :description

      t.timestamps
    end
  end
end
