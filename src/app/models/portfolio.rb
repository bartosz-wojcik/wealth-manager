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
      currency = account.currency
    end
    full_value(currency) + partial_value(currency)
  end

  def current_value_formatted(currency = nil)
    ('%.2f' % current_value(currency)) + account.currency.symbol
  end


  def full_value(currency, categories = nil)
    result_value = 0
    value = full_value_record(categories)
    if value.present?
      # need to recalculate to desired currency
      if value.currency_id != currency.id
        result_value = currency.convert_from(value.value, value.currency)
        # it was not possible to convert currency
        unless result_value.present?
          result_value = value.value
          # @current_currency = full_value.currency
        end
      else
        result_value = value.value
      end
    end

    result_value
  end

  def partial_value(currency, categories = nil)
    result_value = 0
    values = partial_value_record(categories)
    values.each do |pv|
      # need to recalculate to desired currency
      if pv.currency_id != currency.id
        recalculated   = currency.convert_from(pv.value, pv.currency)
        # skip entries which cannot be converted
        result_value += recalculated if recalculated.present?
      else
        result_value += pv.value
      end
    end

    result_value
  end

  private
  def full_value_record(categories = nil)
    if categories.present?
      PortfolioChange
        .joins(:portfolio)
        .where('portfolio_id = ? AND asset_category_id IN (?) AND partial_value = FALSE',
               id, categories)
        .order('entered_date DESC')
        .first
    else
      PortfolioChange
        .joins(:portfolio)
        .where('portfolio_id = ? AND partial_value = FALSE', id)
        .order('entered_date DESC')
        .first
    end
  end

  def partial_value_record(categories = nil)
    if categories.present?
      PortfolioChange
        .select('value, currency_id')
        .joins(:portfolio)
        .where('portfolio_id = ? AND asset_category_id IN (?) AND partial_value = TRUE',
               id, categories)
        .order('entered_date DESC')
    else
      PortfolioChange
        .select('value, currency_id')
        .joins(:portfolio)
        .where('portfolio_id = ? AND partial_value = TRUE', id)
        .order('entered_date DESC')
    end
  end
end
