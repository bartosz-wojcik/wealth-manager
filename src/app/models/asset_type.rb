class AssetType < ApplicationRecord
  has_many :asset_categories

  def current_value(portfolio, currency = nil)
    # currency should be always set
    unless currency.present?
      currency = portfolio.account.currency
    end
    categories = asset_categories.map { |c| c.id }
    # @current_currency = currency
    portfolio.full_value(currency, categories) + portfolio.partial_value(currency, categories)
  end

  def current_value_formatted(portfolio, currency = nil)
    ('%.2f' % current_value(portfolio, currency)) + portfolio.account.currency.symbol
  end

  # def last_value_calculation_currency
  #   @current_currency
  # end
end
