class PortfoliosController < ApplicationController

  before_action :authorize

  def index
    @portfolios = Portfolio.where(account_id: current_account.id).all
  end

  def show
    load_portfolio(params[:id])

    @asset_types = AssetType.all

    @portfolio_transaction = PortfolioChange.new
    @portfolio_transaction.portfolio_id  = @portfolio.id
    @portfolio_transaction.entered_date  = Date.today.to_s
    @portfolio_transaction.partial_value = true

    @portfolio_change = PortfolioChange.new
    @portfolio_change.portfolio_id  = @portfolio.id
    @portfolio_change.entered_date  = Date.today.to_s
    @portfolio_change.partial_value = false
  end

  def new
    @portfolio = Portfolio.new
  end

  def edit
    load_portfolio(params[:id])
  end

  def create
    @portfolio = Portfolio.new(portfolio_params)
    @portfolio.account_id = current_account.id
    @portfolio.save
    redirect_to @portfolio
  end

  def update
  end

  def destroy
  end

  private
  def portfolio_params
    params.require(:portfolio).permit(:name, :description)
  end

end
