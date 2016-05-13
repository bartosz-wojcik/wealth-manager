class Portfolio < ApplicationRecord
  belongs_to :account
  has_many :portfolio_changes
  has_many :net_values

  def currencies
    PortfolioChange
      .select('currencies.name')
      .joins(:currency)
      .where('portfolio_id = ?', self.id)
      .group('currencies.id')
      .all
  end

  def current_value(currency = nil)
    unless currency.present?
      currency = this.account.currency
    end

    # TODO: get the full value of portfolio
    # TODO: include partial updates
  end
end
