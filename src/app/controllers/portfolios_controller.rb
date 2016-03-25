class PortfoliosController < ApplicationController

  before_action :authorize

  def index
    @portfolios = Portfolio.where(account_id: current_account.id).all
  end

  def show
    load_portfolio(params[:id])
  end

  def new
    @portfolio = Portfolio.new
  end

  def edit
    load_portfolio(params[:id])
  end

  def create
  end

  def update
  end

  def destroy
  end

  private
  def load_portfolio(id)
    @portfolio = Portfolio.where(id: id, account_id: current_account.id).first
  end

  def portfolio_params
    # TODO
  end

end
