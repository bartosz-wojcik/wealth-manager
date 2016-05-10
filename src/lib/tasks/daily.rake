namespace :daily do
  desc "Refreshes the currency rates from API"
  task currencies: :environment do
    currency_list = Currency.all
    current_rates = HTTParty.get "https://openexchangerates.org/api/latest.json?app_id=#{FX_RATES_API_KEY}"

    # TODO: put all combinations into the database
    #puts current_rates['timestamp']
  end

end
