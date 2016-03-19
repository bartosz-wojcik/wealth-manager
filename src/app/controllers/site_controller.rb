class SiteController < ApplicationController

  def index
    self.page_title = 'Dashboard'

    if current_account.is_a? Account
      render 'dashboard'
    end
  end

end