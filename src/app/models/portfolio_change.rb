class PortfolioChange < ApplicationRecord
  belongs_to :portfolio
  belongs_to :currency
end
