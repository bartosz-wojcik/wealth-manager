class PortfolioChangesController < ApplicationController

  before_action :authorize

  def create
    @portfolio_change = PortfolioChange.new(portfolio_change_params)
    @portfolio_change.partial_value = false
    @portfolio_change.save

    load_portfolio(@portfolio_change.portfolio_id)
    redirect_to @portfolio
  end

  private
  def portfolio_change_params
    params.require(:portfolio_change).permit(:portfolio_id, :value, :currency_id, :asset_category_id, :entered_date, :notes)
  end

end
