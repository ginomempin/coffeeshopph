class Table < ActiveRecord::Base
  has_many :orders, dependent: :destroy
  has_one :customer, class_name:  "Customer",
                     foreign_key: "table_id",
                     dependent:   :destroy
  has_one :server, through: :customer

  after_validation :toggle_occupied

  validates :name, presence:  true,
                   length:    { maximum: 50 }

  validates :max_persons, numericality: { only_integer: true,
                                          greater_than_or_equal_to: 2,
                                          less_than_or_equal_to: 4 }

  validates :num_persons, numericality: { only_integer: true,
                                          greater_than_or_equal_to: 0,
                                          less_than_or_equal_to: :max_persons }

  validates :total_bill, numericality: { greater_than_or_equal_to: 0 }

  #-------------------
  # Object Methods
  #-------------------

  # Override as_json to limit the fields returned by the Tables API.
  def as_json(options={})
    super( except: [:id, :created_at, :updated_at],
           include:
           {
             orders: { only: [:name, :quantity, :served] },
             server: { only: [:name] }
           }
         )
  end

  # Returns an ordered list of the associated Order objects.
  def order_list
    Order.where(table_id: self.id)
         .order(created_at: :desc)
  end

  # Destroys the Order objects associated with this table.
  # TODO: move to a before_destroy callback of Table?
  def clear_orders
    self.orders.each do |order|
      order.destroy
    end
  end

  #-------------------
  # Private Methods
  #-------------------
  private

    def toggle_occupied
      self.occupied = (self.num_persons > 0 ? true : false)
    end

end
