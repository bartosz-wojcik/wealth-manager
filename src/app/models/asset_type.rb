class AssetType < ApplicationRecord
  has_many :asset_categories

  def current_value_for_portfolio(portfolio)
    # TODO
    12.3
  end
end
