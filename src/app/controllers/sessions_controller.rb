class SessionsController < ApplicationController

  def new
    @account = Account.new
  end

  def save
    @account = Account.find_by_email(account_params[:email])
    if @account.nil?
      @account = Account.new(account_params)
      @account.password_digest = Account::DUMMY_PASSWORD
      @account.generate_activation_key
      if @account.save
        session[:user_id] = @account.id
        # UserMailer.activation_email(@account).deliver_now
        redirect_to root_url
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
    if request.patch? || request.post?
      Rails.logger.debug params.inspect
      @account = Account.find_by_email(params[:email])
      if @account && params[:password].present? && @account.authenticate(params[:password])
        session[:user_id] = @account.id
        redirect_to root_url, flash: { success: 'Welcome to your dashboard!' }
      else
        redirect_to login_url, flash: { danger: 'Incorrect username or password.' }
      end
    end
  end

  def destroy
    session[:user_id] = nil
    reset_session
    redirect_to login_url, flash: { success: 'Logged out.' }
  end

  def activate_start
    if request.post?
      @account = Account.find_by_email(account_params[:email])
      if @account && @account.not_activated?
        @account.generate_activation_key!
        # UserMailer.activation_email(@account).deliver_now
        redirect_to login_url, flash: { success: 'Activation email has been sent.' }
      else
        redirect_to activate_start_url, flash: { danger: 'Provided email address does not point to an inactive account.' }
      end
    else
      @account = Account.new
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
    if request.post?
      @account = Account.find_by_email(account_params[:email])
      if @account && @account.active?
        @account.generate_activation_key!
        # UserMailer.recovery_email(@account).deliver_now
        redirect_to login_url, flash: { success: 'Please check your email to recover your password.' }
      else
        redirect_to recover_start_url, flash: { danger: 'This email address isn\'t associated with an active account.' }
      end
    else
      @account = Account.new
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
end
