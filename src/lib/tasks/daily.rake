namespace :daily do
  desc "Refreshes the currency rates from API"
  task currencies: :environment do
    currency_list = Currency.all.map { |c| c.name }
    updated = 0
    errors  = 0

    # put all combinations into the database
    bases_handled = []
    currencies    = {}
    current_rates = []
    currency_list.combination(2).each do |pair|
      base  = pair[0]
      quote = pair[1]
      currencies[base]  = Currency.find_by_name(base) unless currencies.has_key?(base)
      currencies[quote] = Currency.find_by_name(quote) unless currencies.has_key?(quote)

      unless bases_handled.include?(base)
        bases_handled << base
        current_rates = HTTParty.get "http://api.fixer.io/latest?base=#{base}"
        unless current_rates['rates']
          errors += 1
          next
        end
      end

      # now add the data to the rates table
      rate = CurrencyRate.new
      rate.base_currency_id  = currencies[base].id
      rate.quote_currency_id = currencies[quote].id
      rate.pair_name         = base + quote
      rate.current_rate      = current_rates['rates'][quote]
      rate.rate_cached_time  = Time.now
      updated += 1 if rate.save
    end

    puts "Updated #{updated} currency pairs with #{errors} errors!"
  end

end
