class AssetType < ApplicationRecord
  has_many :asset_categories

  def current_value_for_portfolio(portfolio, currency = nil)
    # currency should be always set
    unless currency.present?
      currency = portfolio.account.currency
    end

    categories = asset_categories.map { |c| c.id }
    # we need to get the latest "complete" portfolio value, if exists
    full_value = PortfolioChange
                      .select('value')
                      .joins(:portfolio)
                      .where('portfolio_id = ? AND asset_category_id IN (?) AND partial_value = FALSE',
                             portfolio.id, categories)
                      .order('entered_date DESC')
                      .first

    current_currency = currency
    if full_value.present?
      # need to recalculate to desired currency
      if full_value.currency_id != currency.id
        current_value = currency.convert_from(full_value.value, full_value.currency)
        # it was not possible to convert currency
        unless current_value.present?
          current_value    = full_value.value
          current_currency = full_value.currency
        end
      else
        current_value    = full_value.value
      end
    else
      current_value    = 0
    end

    # TODO: include partial updates now

    return current_value, current_currency
  end
end
