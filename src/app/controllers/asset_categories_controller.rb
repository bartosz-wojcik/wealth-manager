class AssetCategoriesController < ApplicationController

  before_action :authorize

  def index
    @asset_categories = AssetCategory.where(account_id: current_account.id).all
  end

  def show
    load_asset_category(params[:id])
  end

  def new
    @asset_category = AssetCategory.new
  end

  def edit
    load_asset_category(params[:id])
  end

  def create
  end

  def update
  end

  def destroy
  end

  private
  def load_asset_category(id)
    @asset_category = AssetCategory.where(id: id, account_id: current_account.id).first
  end

  def asset_category_params
    # TODO
  end

end
