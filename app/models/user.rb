class User < ActiveRecord::Base

  validates :name, presence: true
  validates :name, length: { maximum: 50 }

  validates :email, presence: true
  validates :email, length: { maximum: 255 }
  validates :email, email_format: { message: "format does not appear to be valid" }
  validates :email, uniqueness: { case_sensitive: false }

  validates :password, presence: true
  validates :password, length: { minimum: 6 }

  # standardize all input emails to be handled as lowercase
  before_save { self.email.downcase! }

  has_secure_password

  # Class method for getting the hash digest of a given string.
  # This uses the same BCrypt method as 'has_secure_password'.
  # This is only used in setting-up test fixtures for the User model.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

end
