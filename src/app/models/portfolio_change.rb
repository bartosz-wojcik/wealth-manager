class PortfolioChange < ApplicationRecord
  belongs_to :portfolio
  belongs_to :currency
  belongs_to :asset_category
end
