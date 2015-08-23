class User < ActiveRecord::Base

  validates :name, presence: true
  validates :name, length: { maximum: 50 }

  validates :email, presence: true
  validates :email, length: { maximum: 255 }
  validates :email, email_format: { message: "does not appear to be valid email address" }

end
