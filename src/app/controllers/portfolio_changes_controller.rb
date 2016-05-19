class PortfolioChangesController < ApplicationController

  before_action :authorize
  before_filter :fix_value, :only => [ :create ]

  def create
    @portfolio_change = PortfolioChange.new(portfolio_change_params)
    @portfolio_change.save

    load_portfolio(@portfolio_change.portfolio_id)
    redirect_to @portfolio, flash: { success: 'Your portfolio has been updated!' }
  end

  private
  def portfolio_change_params
    params.require(:portfolio_change).permit(
      :portfolio_id,
      :value,
      :currency_id,
      :asset_category_id,
      :entered_date,
      :notes,
      :partial_value
    )
  end

  def fix_value
    # TODO: add fixing other characters, like spaces, $ signs, etc.
    params[:portfolio_change][:value].sub!(',', '.')
  end

end
