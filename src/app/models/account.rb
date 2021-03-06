class Account < ApplicationRecord

  has_secure_password
  belongs_to   :currency

  before_save      :downcase_email
  after_initialize :init_account, if: :new_record?

  validates :email,
              presence: true,
              uniqueness: true,
              format: {
                  with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
              }
  validates :currency_id, presence: true

  STATUS_INACTIVE = 0
  STATUS_ACTIVE   = 1

  DUMMY_PASSWORD  = 'account without password'
  KEY_EXPIRY_DAYS = 1

  def to_s
    self.name.blank? ? self.email : self.name
  end

  def params_name
    self.class.name.downcase.singularize
  end

  def gravatar_url(size = 200)
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(downcase_email)}?d=mm&s=#{size}"
  end

  def no_password?
    self.password_digest == Account::DUMMY_PASSWORD
  end

  def inactive?
    self.status == Account::STATUS_INACTIVE
  end

  def not_activated?
    self.inactive? || self.no_password?
  end

  def active?
    self.status == Account::STATUS_ACTIVE
  end

  def set_inactive!
    self.status = Account::STATUS_INACTIVE
    self.save
  end

  def set_active!
    self.status = Account::STATUS_ACTIVE
    # need to invalidate the previous key
    self.generate_activation_key
    self.save
  end

  def activation_key_valid?(key)
    self.activation_key == key && self.activation_expiry >= DateTime.now ?
        true :
        false
  end

  def generate_activation_key
    self.activation_key    = SecureRandom.urlsafe_base64(64)
    self.activation_expiry = (DateTime.now + KEY_EXPIRY_DAYS.days).strftime('%Y-%m-%d %H:%M:%S')
  end

  def generate_activation_key!
    generate_activation_key
    self.save
  end

  private
  def init_account
    self.currency_id = Currency::DEFAULT_CURRENCY_ID
    self.password_digest = Account::DUMMY_PASSWORD
    self.generate_activation_key
  end

  def downcase_email
    self.email = email.downcase if email.present?
  end
end
