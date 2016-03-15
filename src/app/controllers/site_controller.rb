class SiteController < ApplicationController

  def index
    self.page_title = 'Dashboard'

    if current_account.is_a? Account
      render 'dashboard'
    else
      # for now just redirect to login
      redirect_to :login
    end
  end

end