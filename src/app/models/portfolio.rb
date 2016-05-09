class Portfolio < ApplicationRecord
  has_many :portfolio_changes

  def currencies
    PortfolioChange
      .select('currencies.name')
      .joins(:currency)
      .where('portfolio_id = ?', self.id)
      .group('currencies.id')
      .all
  end

  def get_current_value(currency = nil)

  end
end
