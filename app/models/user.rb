class User < ActiveRecord::Base

  # standardize all input emails to be handled as lowercase
  before_save { self.email.downcase! }

  validates :name, presence: true
  validates :name, length: { maximum: 50 }

  validates :email, presence: true
  validates :email, length: { maximum: 255 }
  validates :email, email_format: { message: "does not appear to be valid email address" }
  validates :email, uniqueness: { case_sensitive: false }

end
