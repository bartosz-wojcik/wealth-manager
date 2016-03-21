class SessionsController < ApplicationController

  before_action :new_account, only: [:new, :activate_start, :recover_start]

  def new
  end

  def save
    @account = Account.find_by_email(account_params[:email])
    if @account.nil?
      @account = Account.new(account_params)
      @account.password_digest = Account::DUMMY_PASSWORD
      @account.generate_activation_key
      if @account.save
        session[:user_id] = @account.id
        AccountMailer.activation_email(@account).deliver_now
        redirect_to root_url, flash: { success: 'Your account has been created!' }
      else
        render 'new'
      end
    elsif @account.not_activated?
      redirect_to signup_url, flash: { danger: 'You need to activate your account first. Please click ' + view_context.link_to('here', activate_start_url) + ' to resend the activation mail.' }
    else
      redirect_to signup_url, flash: { danger: 'This email is already taken.' }
    end
  end

  def create
  end

  def create_post
    @account = Account.find_by_email(params[:email])
    if @account && params[:password].present? && @account.authenticate(params[:password])
      session[:user_id] = @account.id
      redirect_to root_url, flash: { success: 'Welcome to your dashboard!' }
    else
      redirect_to login_url, flash: { danger: 'Incorrect username or password.' }
    end
  end

  def destroy
    session[:user_id] = nil
    reset_session
    redirect_to login_url, flash: { success: 'Logged out.' }
  end

  def activate_start
  end

  def activate_start_post
    @account = Account.find_by_email(account_params[:email])
    if @account && @account.not_activated?
      @account.generate_activation_key!
      AccountMailer.activation_email(@account).deliver_now
      redirect_to login_url, flash: { success: 'Activation email has been sent.' }
    else
      redirect_to activate_start_url, flash: { danger: 'Provided email address does not point to an inactive account.' }
    end
  end

  def activate
    account = Account.find_by_activation_key(params[:key])
    if account && account.not_activated? && account.activation_key_valid?(params[:key])
      account.set_active!
      session[:user_id] = account.id
      redirect_to({controller: 'accounts', action: 'password' }, flash: {success: 'Account activated successfully.<br/>Please set your password now to finish the activation process.' })
    else
      redirect_to activate_start_url, flash: { danger: 'Provided activation link does not point to a valid account or the link has expired.' }
    end
  end

  def recover_start
  end

  def recover_start_post
    @account = Account.find_by_email(account_params[:email])
    if @account && @account.active?
      @account.generate_activation_key!
      AccountMailer.recovery_email(@account).deliver_now
      redirect_to login_url, flash: { success: 'Please check your email to recover your password.' }
    else
      redirect_to recover_start_url, flash: { danger: 'This email address isn\'t associated with an active account.' }
    end
  end

  def recover
    account = Account.find_by_activation_key(params[:key])
    if account && account.active? && account.activation_key_valid?(params[:key])
      # deactivate current key
      account.generate_activation_key!
      session[:user_id] = account.id
      redirect_to({controller: 'accounts', action: 'password' }, flash: {success: 'Please set your new password.' })
    else
      redirect_to recover_start_url, flash: { danger: 'Provided recovery link does not point to a valid account or the link has expired.' }
    end
  end

  def error_404
    self.page_title = 'Error 404'
    render '404'
  end

  private
  def account_params
    params.require(:account).permit(:email)
  end

  def new_account
    @account = Account.new
  end
end
