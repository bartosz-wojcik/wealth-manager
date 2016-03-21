class CreatePortfolios < ActiveRecord::Migration[5.0]
  def change
    create_table :portfolios do |t|
      t.belongs_to :account
      t.string     :name
      t.text       :description

      t.timestamps
    end
  end
end
