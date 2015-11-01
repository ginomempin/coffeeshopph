class User < ActiveRecord::Base

  # These attributes are analogous to the virtual 'password' and
  #  'password_confirmation' attributes automatically created by
  #  the has_secure_password' method.
  attr_accessor :remember_token,
                :activation_token,
                :password_reset_token

  before_create :create_activation_digest
  before_save   :downcase_email

  validates :name, presence:  true,
                   length:    { maximum: 50 }

  validates :email, presence:     true,
                    length:       { maximum: 255 },
                    email_format: { message: "format does not appear to be valid" },
                    uniqueness:   { case_sensitive: false }

  validates :password, presence:  true,
                       length:    { minimum: 6 },
                       allow_nil: true  # allow updating the user profile with an empty password

  has_secure_password

  #-------------------
  # Object Methods
  #-------------------

  # Generates a new remember token for the user and saves it
  #  to the database as a hashed digest. This is analogous to
  #  password_digest saved by the 'has_secure_password' method.
  def remember
    self.remember_token = User.token
    update_attribute(:remember_digest, User.digest(self.remember_token))
  end

  # Returns TRUE if the passed 'token' matches the saved
  #  'digest' in the database. This is analogous to the
  #  'authenticate' method of the 'has_secure_password'
  #  method.
  # This method uses metaprogramming to select the correct
  #  'digest' depending on the attribute.
  #  ex. self.send("password_digest") is equivalent to
  #      self.password_digest
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Reverses the remember method.
  def forget
    self.remember_token = nil
    update_attribute(:remember_digest, nil)
  end

  # Activates the user.
  def activate
    update_columns(activated:    true,
                   activated_at: Time.zone.now)
  end

  # Sends the user activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Generates the password reset token and digest.
  def create_password_reset_digest
    self.password_reset_token = User.token
    update_columns(password_reset_digest:  User.digest(self.password_reset_token),
                   password_reset_sent_at: Time.zone.now)
  end

  # Sends the password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Checks if the password token is still valid
  def password_reset_expired?
    # TODO: the '2' hour expiration should be defined in an app constant
    self.password_reset_sent_at < 2.hours.ago
  end

  #-------------------
  # Class Methods
  #-------------------

  # Generates the hash digest of a given string.
  # This uses the same BCrypt method as 'has_secure_password'.
  # This is only used in setting-up test fixtures for the User model.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Generates a random token.
  # This uses the 'urlsafe_base64' method of the SecureRandom module,
  #  which generates a random 22-character string with each character
  #  having 64 different possibilities. This ensures that the chances
  #  of 2 tokens colliding is about 10^-40. The tokens are also URL safe.
  def User.token
    SecureRandom.urlsafe_base64
  end

  #-------------------
  # Private Methods
  #-------------------
  private

    # Standardizes all input emails to be handled as lowercase.
    def downcase_email
      self.email.downcase!
    end

    # Generates the activation token and digest for new users.
    def create_activation_digest
      self.activation_token = User.token
      self.activation_digest = User.digest(self.activation_token)
    end

end
