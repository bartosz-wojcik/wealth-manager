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
    exclude_records = []
    current_date    = nil

    loop do
      relative_to  = prev_value_record(nil, current_date, exclude_records)
      break unless relative_to.present?

      current_date = relative_to.entered_date
      full_value   = final_value(currency, nil, current_date)
      full_values     << { :date => current_date, :value => '%.2f' % full_value }
      exclude_records << relative_to.id
    end

    full_values.reverse
  end

  def last_month_change
    '0%'
  end

  def portfolio_changes_sorted
    PortfolioChange.where(portfolio_id: id).order('entered_date ASC, id DESC').all
  end

  def portfolio_history_sorted
    changes = portfolio_changes_sorted
    totals  = {}
    result  = []
    previous_total = 0

    changes.each do |pc|
      unless totals.key?(pc.asset_category_id)
        totals[pc.asset_category_id] = 0
      end
      if pc.partial_value
        totals[pc.asset_category_id] += pc.value
      else
        totals[pc.asset_category_id] = pc.value
      end

      current_total = 0
      totals.each do |cid, value|
        current_total += value
      end
      result << {
        :date   => pc.entered_date,
        :total  => current_total,
        :amount => current_total - previous_total,
        :pc     => pc
      }
      previous_total = current_total
    end

    result
  end

  def final_value(currency = nil, categories = nil, for_date = nil)
    unless currency.present?
      currency = account.currency
    end
    unless for_date.present?
      for_date = Date.today
    end
    result_value = 0
    records = value_records(for_date, categories)
    # go through all records...
    records.each do |category_id, value_hash|
      value_hash[:change].each do |value|
        # need to recalculate to desired currency
        if value.currency_id != currency.id
          recalculated = currency.convert_from(value.value, value.currency)
          if recalculated.present?
            result_value = value_hash[:category].asset_type.is_debt ?
                result_value - recalculated :
                result_value + recalculated
          else
            # it was not possible to convert currency
            #result_value = value.change.value
            # TODO: add handling of this situation
            #@current_currency = full_value.currency
          end
        else
          result_value = value_hash[:category].asset_type.is_debt ?
              result_value - value.value :
              result_value + value.value
        end
        # ...until a full value is found
        break unless value.partial_value
      end
    end

    result_value
  end

  def all_categories
    if @categories.nil?
      @categories = AssetCategory.where('account_id IS NULL OR account_id = ?', self.account_id)
    end
    @categories
  end

  private
  def prev_value_record(categories = nil, relative_to = nil, exclude_records = [])
    if categories.blank?
      categories = all_categories.to_a
    end

    change = PortfolioChange.order('entered_date DESC, id DESC')
    if exclude_records.empty?
      change = change.where('portfolio_id = ? AND asset_category_id IN (?) AND entered_date <= ?',
                            id, categories, relative_to.present? ? relative_to : Date.today)
    else
      change = change.where('portfolio_id = ? AND asset_category_id IN (?) AND entered_date <= ?' +
                                ' AND id NOT IN (?)',
                            id, categories, relative_to.present? ? relative_to : Date.today,
                            exclude_records)
    end

    change.first
  end

  def value_records(for_date, categories = nil)
    records = {}
    if categories.nil?
      categories = self.all_categories
    end
    # gets all portfolio changes grouped by category
    categories.each do |c|
      records[c.id] = {
          :change => PortfolioChange
                         .where('portfolio_id = ? AND asset_category_id = ? AND entered_date <= ?',
                                id, c.id, for_date)
                         .order('entered_date DESC, id DESC')
                         .all.to_a,
          :category => c
      }
    end
    records
  end
end
