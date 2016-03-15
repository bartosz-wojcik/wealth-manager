class SiteController < ApplicationController

  def index
    # for now just redirect to login
    redirect_to :login
  end

end