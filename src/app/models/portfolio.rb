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
    '%.2f' % (full_value(currency) + partial_value(currency))
  end

  def current_value_formatted(currency = nil)
    current_value(currency) + account.currency.symbol
  end

  def historical_values(currency = nil)
    unless currency.present?
      currency = account.currency
    end
    full_values   = []
    relative_to   = nil
    current_value = 0

    loop do
      current_record = next_value_record(nil, nil, relative_to)
      break unless current_record.present?

      if current_record.currency_id != currency.id
        result_value = currency.convert_from(current_record.value, current_record.currency)
        # it was not possible to convert currency
        unless result_value.present?
          result_value = current_record.value
          # TODO: add handling of this situation
          # @current_currency = full_value.currency
        end
      else
        result_value = current_record.value
      end

      relative_to   = current_record
      current_value = current_record.partial_value ?
          current_value + result_value : result_value
      full_values << { :date => relative_to.entered_date, :value => '%.2f' % current_value }
    end

    full_values
  end


  def full_value(currency, categories = nil)
    result_value = 0
    value = value_record(false, categories)
    if value.present?
      # need to recalculate to desired currency
      if value.currency_id != currency.id
        result_value = currency.convert_from(value.value, value.currency)
        # it was not possible to convert currency
        unless result_value.present?
          result_value = value.value
          # TODO: add handling of this situation
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
    values = value_record(true, categories)
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
  def next_value_record(partial_value, categories = nil, relative_to = nil)
    if categories.present?
      change = PortfolioChange.joins(:portfolio).order('entered_date ASC, id ASC')
      if partial_value == nil
        change = change
           .where('portfolio_id = ? AND asset_category_id IN (?) AND entered_date >= ? AND portfolio_changes.id > ?',
                  id, categories, relative_to.present? ? relative_to.entered_date : '1900-01-01',
                  relative_to.present? ? relative_to.id : 0
           )
      else
        change = change
           .where('portfolio_id = ? AND asset_category_id IN (?) AND partial_value = ? AND entered_date >= ? ' +
                      'AND portfolio_changes.id > ?',
                  id, categories, partial_value ? true : false,
                  relative_to.present? ? relative_to.entered_date : '1900-01-01',
                  relative_to.present? ? relative_to.id : 0
           )
      end
    else
      change = PortfolioChange.joins(:portfolio).order('entered_date ASC, id ASC')
      if partial_value == nil
        change = change
           .where('portfolio_id = ? AND entered_date >= ? AND portfolio_changes.id > ?',
                  id, relative_to.present? ? relative_to.entered_date : '1900-01-01',
                  relative_to.present? ? relative_to.id : 0
           )
      else
        change = change
           .where('portfolio_id = ? AND partial_value = ? AND entered_date >= ? AND portfolio_changes.id > ?',
                  id, partial_value ? true : false, relative_to.present? ? relative_to.entered_date : '1900-01-01',
                  relative_to.present? ? relative_to.id : 0
           )
      end
    end
    change.first
  end

  def value_record(partial_value, categories = nil)
    if categories.present?
      change = PortfolioChange
        .joins(:portfolio)
        .where('portfolio_id = ? AND asset_category_id IN (?) AND partial_value = ?',
               id, categories, partial_value ? true : false)
        .order('entered_date DESC')
    else
      change = PortfolioChange
        .joins(:portfolio)
        .where('portfolio_id = ? AND partial_value = ?',
               id, partial_value ? true : false)
        .order('entered_date DESC')
    end

    partial_value ? change : change.first
  end
end
