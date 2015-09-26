class User < ActiveRecord::Base

  # This attribute is analogous to the virtual 'password' and
  #  'password_confirmation' attributes automatically created
  #  by 'has_secure_password'.
  attr_accessor :remember_token

  validates :name, presence:  true,
                   length:    { maximum: 50 }

  validates :email, presence:     true,
                    length:       { maximum: 255 },
                    email_format: { message: "format does not appear to be valid" },
                    uniqueness:   { case_sensitive: false }

  validates :password, presence:  true,
                       length:    { minimum: 6 },
                       allow_nil: true

  # standardize all input emails to be handled as lowercase
  before_save { self.email.downcase! }

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

  # Returns TRUE if the passed 'remember_token' matches the saved
  #  'remember_digest' in the database. This is analogous to the
  #  'authenticate' method of the 'has_secure_password' method.
  def authenticated?(remember_token)
    return false if self.remember_digest.nil?
    BCrypt::Password.new(self.remember_digest).is_password?(remember_token)
  end

  # Reverses the remember method.
  def forget
    self.remember_token = nil
    update_attribute(:remember_digest, nil)
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

end
