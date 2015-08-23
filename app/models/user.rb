class User < ActiveRecord::Base

  validates :name, presence: true
  validates :name, length: { maximum: 50 }

  validates :email, presence: true
  validates :email, length: { maximum: 255 }
  validates :email, email_format: { message: "does not appear to be valid email address" }
  validates :email, uniqueness: { case_sensitive: false }

  validates :password, presence: true
  validates :password, length: { minimum: 6 }

  # standardize all input emails to be handled as lowercase
  before_save { self.email.downcase! }

  has_secure_password

end
