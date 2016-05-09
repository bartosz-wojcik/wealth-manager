class AssetType < ApplicationRecord
  has_many :asset_categories

  def current_value_for_portfolio(portfolio, currency = nil)
    categories = asset_categories.map { |c| c.id }
    # we need to get the latest "complete" portfolio value, if exists
    full_value = PortfolioChange
                      .select('value')
                      .joins(:portfolio)
                      .where('portfolio_id = ? AND asset_category_id IN (?) AND partial_value = FALSE',
                             portfolio.id, categories)
                      .order('entered_date DESC')
                      .limit(1)
                      .first

    if full_value.present?
      current_value = full_value.value
      # TODO: need to recalculate to base currency if needed
      if currency.present?

      end
    else
      current_value = 0
    end

    # TODO: include partial updates now
    current_value
  end
end
