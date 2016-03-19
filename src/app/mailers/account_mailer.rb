class AccountMailer < ApplicationMailer
  default from: 'NetValue <netvalue@procreative.eu>'

  def activation_email(account)
    @account = account
    @url     = url_for(activate_url(:key => @account.activation_key))
    mail(to: @account.email, subject: 'Welcome to NetValue')
  end

  def recovery_email(account)
    @account = account
    @url     = url_for(recover_url(:key => @account.activation_key))
    mail(to: @account.email, subject: 'Password recovery link for NetValue')
  end
end
