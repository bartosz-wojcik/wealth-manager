class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  attr_accessor :page_title, :parent_link

  def authorize
    if current_account.nil?
      redirect_to login_url
    end
  end

  def load_account
    @account = current_account
  end

  def load_current_portfolio
    @current_portfolio = Portfolio.where(account_id: current_account.id).first
  end

  private
  def current_account
    Account.where(id: session[:user_id]).first
  end

  def load_portfolio(id)
    @portfolio = Portfolio.where(id: id, account_id: current_account.id).first
  end

  helper_method :current_account, :page_title, :parent_link
end
