class Customer < ActiveRecord::Base
  belongs_to :server, class_name: "User"
  belongs_to :table

  validates :server_id, presence: true
  validates :table_id, presence: true
end
