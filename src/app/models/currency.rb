class Currency < ApplicationRecord
  def full_name
    "#{description} (#{name})"
  end

  def get_latest_rate(relative_to)
    CurrencyRate
      .where('base_currency_id = ? AND quote_currency_id = ? OR ' +
             'base_currency_id = ? AND quote_currency_id = ?', this.id, relative_to.id, relative_to.id, this.id)
      .order('rate_date DESC')
      .first
  end

  def convert_from(amount, from_currency)
    latest_rate = get_latest_rate from_currency
    return nil unless latest_rate.present?

    # recalculate depending on the "direction" of the currency rate
    if latest_rate.base_currency_id == from_currency.id
      amount * latest_rate.current_rate
    else
      amount / latest_rate.current_rate
    end
  end

  def format(amount)

  end
end
