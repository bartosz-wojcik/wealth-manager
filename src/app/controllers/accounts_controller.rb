class AccountsController < ApplicationController

  before_action :authorize
  before_action :load_account

  def details
    self.page_title = 'Account Details'
    @asset_types = AssetType.all
  end

  def details_post
    @account.attributes = account_params()
    save_and_redirect 'Profile updated successfully.'
  end

  def password_post
    @account.attributes = password_params()
    save_and_redirect 'Password changed successfully.'
  end

  def notifications_post
  end

  def settings_post
    @account.attributes = settings_params()
    update_asset_categories
    save_and_redirect 'Settings changed successfully.'
  end

  def resend_activation
    if @account.not_activated?
      @account.generate_activation_key!
      AccountMailer.activation_email(@account).deliver_now
      redirect_to root_url, flash: { success: 'Activation email has been sent.' }
    else
      redirect_to root_url
    end
  end

  private
  def update_asset_categories

  end

  def save_and_redirect(message)
    if @account.save
      redirect_to({ action: 'details' }, flash: { success: message })
    else
      redirect_to({ action: 'details' }, flash: { danger: @account.errors.full_messages.join('<br/>') })
    end
  end

  def password_params()
    params.require(@account.params_name).permit(:password)
  end

  def account_params()
    params.require(@account.params_name).permit(:name, :email)
  end

  def settings_params()
    params.require(@account.params_name).permit(:currency_id)
  end
end
