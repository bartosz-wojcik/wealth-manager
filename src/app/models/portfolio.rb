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
    '%.2f' % final_value(currency)
  end

  def current_value_formatted(currency = nil)
    current_value(currency) + account.currency.symbol
  end

  def historical_values(currency = nil)
    unless currency.present?
      currency = account.currency
    end
    full_values     = []
    relative_to     = nil
    current_value   = 0
    exclude_records = []

    loop do
      current_record = next_value_record(nil, nil, relative_to, exclude_records)
      break unless current_record.present?

      exclude_records << current_record.id
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

  def last_month_change
    '0%'
  end


  def final_value(currency, categories = nil)
    result_value = 0
    records = value_records(categories)
    # go through all records...
    records.each do |category, values|
      values.each do |value|
        # need to recalculate to desired currency
        if value.currency_id != currency.id
          recalculated = currency.convert_from(value.value, value.currency)
          if recalculated.present?
            result_value += recalculated
          else
            # it was not possible to convert currency
            #result_value = value.value
            # TODO: add handling of this situation
            #@current_currency = full_value.currency
          end
        else
          result_value += value.value
        end
        # ...until a full value is found
        break unless value.partial_value
      end
    end

    result_value
  end

  def all_categories
    AssetCategory
      .where('account_id IS NULL OR account_id = ?', self.account_id)
      .all
  end

  private
  def next_value_record(partial_value, categories = nil, relative_to = nil, exclude_records = [])
    if categories.present?
      change = PortfolioChange.joins(:portfolio).order('entered_date ASC, id ASC')
      if partial_value == nil
        change = change
           .where('portfolio_id = ? AND asset_category_id IN (?) AND entered_date >= ?' +
                    ' AND portfolio_changes.id NOT IN (?)',
                  id, categories, relative_to.present? ? relative_to.entered_date : '1900-01-01',
                  exclude_records
           )
      else
        change = change
           .where('portfolio_id = ? AND asset_category_id IN (?) AND partial_value = ? AND entered_date >= ?' +
                    ' AND portfolio_changes.id NOT IN (?)',
                  id, categories, partial_value ? true : false,
                  relative_to.present? ? relative_to.entered_date : '1900-01-01',
                  exclude_records
           )
      end
    else
      change = PortfolioChange.joins(:portfolio).order('entered_date ASC, id ASC')
      if partial_value == nil
        change = change
           .where('portfolio_id = ? AND entered_date >= ?' +
                    ' AND portfolio_changes.id NOT IN (?)',
                  id, relative_to.present? ? relative_to.entered_date : '1900-01-01',
                  exclude_records
           )
      else
        change = change
           .where('portfolio_id = ? AND partial_value = ? AND entered_date >= ?' +
                    ' AND portfolio_changes.id NOT IN (?)',
                  id, partial_value ? true : false, relative_to.present? ? relative_to.entered_date : '1900-01-01',
                  exclude_records
           )
      end
    end
    change.first
  end

  def value_records(categories = nil)
    records = {}
    if categories.blank?
      categories = self.all_categories.to_a
    end
    # gets all portfolio changes grouped by category
    categories.each do |c|
      records[c] = PortfolioChange
                    .joins(:portfolio)
                    .where('portfolio_id = ? AND asset_category_id = ?', id, c)
                    .order('entered_date DESC')
                    .all.to_a
    end
    records
  end
end
