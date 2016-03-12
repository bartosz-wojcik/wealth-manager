class AccountsController < ApplicationController
  before_action :authorize

  def details
    self.page_title = 'Account Details'
    @account = current_account
    if request.patch? || request.post?
      @account.attributes = account_params(@account.params_name)
      if @account.save
        redirect_to({ action: 'details' }, flash: { success: 'Profile updated successfully.' })
      end
    end
  end

  def password
    self.parent_link = view_context.link_to('Account Details', { action: 'details' })
    self.page_title = 'Change account password'
    @account = current_account
    if request.patch? || request.post?
      @account.attributes = password_params(@account.params_name)
      if @account.save
        redirect_to({ action: 'details' }, flash: { success: 'Password changed successfully.' })
      end
    end
  end

  def resend_activation
    account = current_account
    if account.not_activated?
      account.generate_activation_key!
      # UserMailer.activation_email(account).deliver_now
      redirect_to root_url, flash: { success: 'Activation email has been sent.' }
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
