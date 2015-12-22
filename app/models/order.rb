class Order < ActiveRecord::Base
  belongs_to :table

  default_scope -> { order(created_at: :desc) }

  validates :name, presence:  true,
                   length:    { maximum: 50 }

  validates :price, numericality: { greater_than_or_equal_to: 0,
                                    less_than_or_equal_to: 99999.99 }

  validates :quantity, numericality: { only_integer: true,
                                       greater_than_or_equal_to: 1 }

  validates :table_id, presence: true

  #-------------------
  # Object Methods
  #-------------------

  # Override as_json to limit the fields returned by the Orders API.
  def as_json(options={})
    super( except: [:table_id, :created_at, :updated_at] )
  end

end
