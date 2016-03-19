class AccountsController < ApplicationController

  before_action :authorize
  before_action :load_account

  def details
    self.page_title = 'Account Details'
  end

  def details_post
    @account.attributes = account_params(@account.params_name)
    if @account.save
      redirect_to({ action: 'details' }, flash: { success: 'Profile updated successfully.' })
    else
      redirect_to({ action: 'details' }, flash: { danger: @account.errors.full_messages.join('<br/>') })
    end
  end

  def password
    self.parent_link = view_context.link_to('Account Details', { action: 'details' })
    self.page_title = 'Change account password'
  end

  def password_post
    @account.attributes = password_params(@account.params_name)
    if @account.save
      redirect_to({ action: 'details' }, flash: { success: 'Password changed successfully.' })
    else
      redirect_to({ action: 'password' }, flash: { danger: @account.errors.full_messages.join('<br/>') })
    end
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
  def password_params(params_name)
    params.require(params_name).permit(:password, :password_confirmation)
  end

  def account_params(params_name)
    params.require(params_name).permit(:name, :email)
  end
end
