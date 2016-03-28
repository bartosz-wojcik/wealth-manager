class SiteController < ApplicationController

  def index
    self.page_title = 'Dashboard'

    if current_account.is_a? Account
      @portfolio = Portfolio.where(account_id: current_account.id).first
      if @portfolio.present?
        redirect_to @portfolio
      else
        @portfolio = Portfolio.new
        render 'dashboard'
      end
    end
  end

end